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

        def connect(host, port, timeout = 1.0)
          addr = Socket.getaddrinfo(host, nil)

          @sock = Socket.new(:INET, :STREAM, 0)
          @sock.setsockopt(Socket::SOL_SOCKET, Socket::SO_RCVTIMEO, secs_to_timeval(timeout)) unless timeout.nil? or timeout.zero?

          begin
            @sock.connect(Socket.pack_sockaddr_in(port, addr[0][3])).zero?
          rescue
            false
          end
        end

        def list_buckets
          send_message(Messages::LIST_BUCKETS_REQ)
          response = receive_response
        end

        private
        def secs_to_timeval(timeout)
          secs = Integer(timeout)
          usecs = Integer((timeout - secs) * 1_000_000)
          [secs, usecs].pack('l_2')
        end

        def send_message(number, message = '')
          length = message.length + 1
          encoded_length = [length].pack("N")    # Big endian long
          encoded_number = [number].pack("N")[3] # 1 byte

          packet = encoded_length + encoded_number + message
          @sock.send packet, 0
          @sock.recv
        end

        def receive_response
          length = @sock.recv(4).unpack("N") - 1
          message_type = @sock.recv(1).ord
          message = @sock.recv(length)
          message
        end
      end
    end
  end
end