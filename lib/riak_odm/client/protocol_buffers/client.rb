require 'socket'

module RiakOdm
  module Client
    module ProtocolBuffers
      class Client
        # Instantiate a new client and attempts to connect to one of the given servers.
        # Accepts a +timeout+ parameter that will influence connection and reads.
        # If +timeout+ is not given, a default timeout of 1 second will be used. To disable timeouts, pass +nil+.
        #
        # @example Setup and connect
        #   begin
        #     client = RiakOdm::Client::ProtocolBuffers::Client.new([
        #       { host: '192.168.1.12', port: 10017 },
        #       { host: '192.168.1.13', port: 10017 },
        #       { host: '192.168.1.14', port: 10017 }
        #     ])
        #   rescue RiakOdm::Errors::Connection
        #   end
        #
        # @raise RiakOdm::Errors::Connection
        def initialize(servers, timeout = 1)
          servers = servers.clone

          @timeout = timeout

          s = servers.delete(servers.sample)
          begin
            return if connect(s[:host], s[:port])
            s = servers.delete(servers.sample)
          end until s.nil?

          raise RiakOdm::Errors::Connection
        end

        # Estabilishes a TCP connection to a given +host+ and +port+, using the optional +timeout+.
        # The connection is absolutely generic and it's not specific for Protocol Buffers use.
        #
        # @example Connect to google.com
        #   client.connect('www.google.com', 80, 3)
        #
        # @return [Boolean] true if connection succeedes, false if not (whether timed-out or anything).
        def connect(host, port, timeout = nil)
          addr = Socket.getaddrinfo(host, nil)

          @sock = Socket.new(:INET, :STREAM, 0)
          real_connect(@sock, addr[0][3], port, timeout || @timeout)
        end

        # Returns an array of strings containing all buckets in the Riak Cluster.
        # Requires an active connection.
        #
        # @example Get the list of buckets
        #    @buckets = client.list_buckets
        #
        # @return [Array] all the bucket names
        #
        # @warning Use of this method is STRONGLY discouraged in production environments. It performs a full scan on
        # all the nodes of the clusters, increasing their load. Also this makes it a slow method.
        def list_buckets
          send_message(Messages::LIST_BUCKETS_REQ)
          receive_response.buckets
        end

        # Returns an array of strings containing all keys in the given +bucket+.
        # Requires an active connection.
        #
        # @example Get the list of keys in bucket +posts+
        #    @keys = client.list_keys('posts')
        #
        # @returns [Array] all the keys in the cluster
        #
        # @warning Use of this method is STRONGLY discouraged in production environments. It performs a full scan on
        # all the nodes of the clusters, increasing their load. Also this makes it a slow method.
        def list_keys(bucket)
          message = Messages::RpbListKeysReq.new(bucket: bucket)
          send_message(Messages::LIST_KEYS_REQ, message.serialize_to_string)

          keys = []
          begin
            response = receive_response
            keys += response.keys
          end until response.done

          keys
        end

        private
        def real_connect(sock, host, port, timeout)
          begin
            sock.connect_nonblock(Socket.pack_sockaddr_in(port, host))
          rescue Errno::EINPROGRESS
            resp = IO.select([sock], [sock], nil, timeout.to_i)
            return false if resp.nil?
            true
          end
        end

        def send_message(number, message = '')
          length = message.length + 1
          encoded_length = [length].pack("N")    # Big endian long
          encoded_number = [number].pack("N")[3] # 1 byte

          packet = encoded_length + encoded_number + message
          @sock.send packet, 0
        end

        def receive_response(timeout = nil)
          if IO.select([@sock], nil, nil, timeout || @timeout).nil?
            raise RiakOdm::Errors::Timeout
          end

          length = @sock.recv(4).unpack("N")[0] - 1
          message_type = @sock.recv(1).ord

          if length
            message = @sock.recv(length)
          else
            message = ''
          end

          if message_type == Messages::ERROR_RESP
            raise RiakOdm::Errors::ServerError
          end

          Messages::MESSAGE_CLASSES[message_type].parse message
        end
      end
    end
  end
end