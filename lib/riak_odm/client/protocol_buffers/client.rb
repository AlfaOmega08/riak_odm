require 'socket'

module RiakOdm
  module Client
    module ProtocolBuffers
      class Client
        def initialize(servers)
          servers = servers.clone

          s = servers.delete(servers.sample)
          begin
            return if connect(s[:host], s[:port])
            s = servers.delete(servers.sample)
          end until s.nil?

          raise RiakOdm::Errors::Connection
        end

        def connect(host, port, timeout = 1)
          addr = Socket.getaddrinfo(host, nil)

          @sock = Socket.new(:INET, :STREAM, 0)
          begin
            real_connect(@sock, addr[0][3], port, timeout)
          rescue
            false
          end
        end

        def list_buckets
          send_message(Messages::LIST_BUCKETS_REQ)
          response = receive_response
        end

        private
        def real_connect(sock, host, port, timeout)
          begin
            sock.connect_nonblock(Socket.pack_sockaddr_in(port, host))
          rescue Errno::EINPROGRESS
            resp = IO.select([sock], nil, nil, timeout.to_i)
            raise Errno::ECONNREFUSED if resp.nil?
          end
        end

        def send_message(number, message = '')
          length = message.length + 1
          encoded_length = [length].pack("N")    # Big endian long
          encoded_number = [number].pack("N")[3] # 1 byte

          packet = encoded_length + encoded_number + message
          @sock.send packet, 0
          @sock.recv
        end

        def receive_response(timeout = 1.0)
          if IO.select([@sock], nil, nil, timeout.to_i).nil?
            raise RiakOdm::Errors::Timeout
          end

          length = @sock.recv(4).unpack("N") - 1
          message_type = @sock.recv(1).ord

          if length
            message = @sock.recv(length)
          else
            message = ''
          end

          Messages.MessageClasses[message_type].parse message
        end
      end
    end
  end
end