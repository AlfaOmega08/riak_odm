require 'protocol_buffers'

module RiakOdm
  module Client
    module ProtocolBuffers
      module Messages
        ERROR_RESP = 0
        PING_REQ = 1
        PING_RESP = 2
        GET_CLIENTID_REQ = 3
        GET_CLIENTID_RESP = 4
        SET_CLIENTID_REQ = 5
        SET_CLIENTID_RESP = 6
        GET_SERVERINFO_REQ = 7
        GET_SERVERINFO_RESP = 8
        GET_REQ = 9
        GET_RESP = 10
        PUT_REQ = 11
        PUT_RESP = 12
        DEL_REQ = 13
        DEL_RESP = 14
        LIST_BUCKETS_REQ = 15
        LIST_BUCKETS_RESP = 16
        LIST_KEYS_REQ = 17
        LIST_KEYS_RESP = 18
        GET_BUCKET_REQ = 19
        GET_BUCKET_RESP = 20
        SET_BUCKET_REQ = 21
        SET_BUCKET_RESP = 22
        MAP_RED_REQ = 23
        MAP_RED_RESP = 24
        INDEX_REQ = 25
        INDEX_RESP = 26
        SEARCH_QUERY_REQ = 27
        SEARCH_QUERY_RESP = 28

        class RpbModFun < ::ProtocolBuffers::Message
          required :bytes, :module, 1
          required :bytes, :function, 2
        end

        class RpbLink < ::ProtocolBuffers::Message
          optional :bytes, :bucket, 1
          optional :bytes, :key, 2
          optional :bytes, :tag, 3
        end

        class RpbPair < ::ProtocolBuffers::Message
          required :bytes, :key, 1
          optional :bytes, :value, 2
        end

        class RpbCommitHook < ::ProtocolBuffers::Message
          optional RpbModFun, :modfun, 1
          optional :bytes, :name, 2
        end

        class RpbBucketProps < ::ProtocolBuffers::Message
          optional :uint32, :n_val, 1
          optional :bool, :allow_mult, 2
          optional :bool, :last_write_wins, 3
          repeated RpbCommitHook, :precommit, 4
          optional :bool, :has_precommit, 5, :default => false
          repeated RpbCommitHook, :postcommit, 6
          optional :bool, :has_postcommit, 7, :default => false
          optional RpbModFun, :chash_keyfun, 8
          optional RpbModFun, :linkfun, 9
          optional :uint32, :old_vclock, 10
          optional :uint32, :young_vclock, 11
          optional :uint32, :big_vclock, 12
          optional :uint32, :small_vclock, 13
          optional :uint32, :pr, 14
          optional :uint32, :r, 15
          optional :uint32, :w, 16
          optional :uint32, :pw, 17
          optional :uint32, :dw, 18
          optional :uint32, :rw, 19
          optional :bool, :basic_quorum, 20
          optional :bool, :notfound_ok, 21
          optional :bytes, :backend, 22
          optional :bool, :search, 23
          module RpbReplMode
            include ::ProtocolBuffers::Enum
            FALSE = 0
            REALTIME = 1
            FULLSYNC = 2
            TRUE = 3
          end
          optional RpbReplMode, :repl, 24
        end

        class RpbContent < ::ProtocolBuffers::Message
          required :bytes, :value, 1
          optional :bytes, :content_type, 2
          optional :bytes, :charset, 3
          optional :bytes, :content_encoding, 4
          optional :bytes, :vtag, 5
          repeated RpbLink, :links, 6
          optional :uint32, :last_mod, 7
          optional :uint32, :last_mod_usecs, 8
          repeated RpbPair, :usermeta, 9
          repeated RpbPair, :indexes, 10
          optional :bool, :deleted, 11
        end

        class RpbGetResp < ::ProtocolBuffers::Message
          repeated RpbContent, :content, 1
          optional :bytes, :vclock, 2
          optional :bool, :unchanged, 3
        end

        class RpbIndexObject < ::ProtocolBuffers::Message
          required :bytes, :key, 1
          required RpbGetResp, :object, 2
        end

        class RpbErrorResp < ::ProtocolBuffers::Message
          required :bytes, :errmsg, 1
          required :uint32, :errcode, 2
        end

        class RpbGetServerInfoResp < ::ProtocolBuffers::Message
          optional :bytes, :node, 1
          optional :bytes, :server_version, 2
        end

        class RpbGetBucketReq < ::ProtocolBuffers::Message
          required :bytes, :bucket, 1
        end

        class RpbGetBucketResp < ::ProtocolBuffers::Message
          required RpbBucketProps, :props, 1
        end

        class RpbSetBucketReq < ::ProtocolBuffers::Message
          required :bytes, :bucket, 1
          required RpbBucketProps, :props, 2
        end

        class RpbResetBucketReq < ::ProtocolBuffers::Message
          required :bytes, :bucket, 1
        end

        class RpbGetClientIdResp < ::ProtocolBuffers::Message
          required :bytes, :client_id, 1
        end

        class RpbSetClientIdReq < ::ProtocolBuffers::Message
          required :bytes, :client_id, 1
        end

        class RpbGetReq < ::ProtocolBuffers::Message
          required :bytes, :bucket, 1
          required :bytes, :key, 2
          optional :uint32, :r, 3
          optional :uint32, :pr, 4
          optional :bool, :basic_quorum, 5
          optional :bool, :notfound_ok, 6
          optional :bytes, :if_modified, 7
          optional :bool, :head, 8
          optional :bool, :deletedvclock, 9
          optional :uint32, :timeout, 10
          optional :bool, :sloppy_quorum, 11
          optional :uint32, :n_val, 12
        end

        class RpbPutReq < ::ProtocolBuffers::Message
          required :bytes, :bucket, 1
          optional :bytes, :key, 2
          optional :bytes, :vclock, 3
          required RpbContent, :content, 4
          optional :uint32, :w, 5
          optional :uint32, :dw, 6
          optional :bool, :return_body, 7
          optional :uint32, :pw, 8
          optional :bool, :if_not_modified, 9
          optional :bool, :if_none_match, 10
          optional :bool, :return_head, 11
          optional :uint32, :timeout, 12
          optional :bool, :asis, 13
          optional :bool, :sloppy_quorum, 14
          optional :uint32, :n_val, 15
        end

        class RpbPutResp < ::ProtocolBuffers::Message
          repeated RpbContent, :content, 1
          optional :bytes, :vclock, 2
          optional :bytes, :key, 3
        end

        class RpbDelReq < ::ProtocolBuffers::Message
          required :bytes, :bucket, 1
          required :bytes, :key, 2
          optional :uint32, :rw, 3
          optional :bytes, :vclock, 4
          optional :uint32, :r, 5
          optional :uint32, :w, 6
          optional :uint32, :pr, 7
          optional :uint32, :pw, 8
          optional :uint32, :dw, 9
          optional :uint32, :timeout, 10
          optional :bool, :sloppy_quorum, 11
          optional :uint32, :n_val, 12
        end

        class RpbListBucketsReq < ::ProtocolBuffers::Message
          optional :uint32, :timeout, 1
          optional :bool, :stream, 2
        end

        class RpbListBucketsResp < ::ProtocolBuffers::Message
          repeated :bytes, :buckets, 1
          optional :bool, :done, 2
        end

        class RpbListKeysReq < ::ProtocolBuffers::Message
          required :bytes, :bucket, 1
          optional :uint32, :timeout, 2
        end

        class RpbListKeysResp < ::ProtocolBuffers::Message
          repeated :bytes, :keys, 1
          optional :bool, :done, 2
        end

        class RpbMapRedReq < ::ProtocolBuffers::Message
          required :bytes, :request, 1
          required :bytes, :content_type, 2
        end

        class RpbMapRedResp < ::ProtocolBuffers::Message
          optional :uint32, :phase, 1
          optional :bytes, :response, 2
          optional :bool, :done, 3
        end

        class RpbIndexReq < ::ProtocolBuffers::Message
          module IndexQueryType
            include ::ProtocolBuffers::Enum
            Eq = 0
            Range = 1
          end
          required :bytes, :bucket, 1
          required :bytes, :index, 2
          required IndexQueryType, :qtype, 3
          optional :bytes, :key, 4
          optional :bytes, :range_min, 5
          optional :bytes, :range_max, 6
          optional :bool, :return_terms, 7
          optional :bool, :stream, 8
          optional :uint32, :max_results, 9
          optional :bytes, :continuation, 10
          optional :uint32, :timeout, 11
        end

        class RpbIndexResp < ::ProtocolBuffers::Message
          repeated :bytes, :keys, 1
          repeated RpbPair, :results, 2
          optional :bytes, :continuation, 3
          optional :bool, :done, 4
        end

        class RpbCSBucketReq < ::ProtocolBuffers::Message
          required :bytes, :bucket, 1
          required :bytes, :start_key, 2
          optional :bytes, :end_key, 3
          optional :bool, :start_incl, 4, :default => true
          optional :bool, :end_incl, 5, :default => false
          optional :bytes, :continuation, 6
          optional :uint32, :max_results, 7
          optional :uint32, :timeout, 8
        end

        class RpbCSBucketResp < ::ProtocolBuffers::Message
          repeated RpbIndexObject, :objects, 1
          optional :bytes, :continuation, 2
          optional :bool, :done, 3
        end

        class RpbCounterUpdateReq < ::ProtocolBuffers::Message
          required :bytes, :bucket, 1
          required :bytes, :key, 2
          required :sint64, :amount, 3
          optional :uint32, :w, 4
          optional :uint32, :dw, 5
          optional :uint32, :pw, 6
          optional :bool, :returnvalue, 7
        end

        class RpbCounterUpdateResp < ::ProtocolBuffers::Message
          optional :sint64, :value, 1
        end

        class RpbCounterGetReq < ::ProtocolBuffers::Message
          required :bytes, :bucket, 1
          required :bytes, :key, 2
          optional :uint32, :r, 3
          optional :uint32, :pr, 4
          optional :bool, :basic_quorum, 5
          optional :bool, :notfound_ok, 6
        end

        class RpbCounterGetResp < ::ProtocolBuffers::Message
          optional :sint64, :value, 1
        end

        class RpbSearchDoc < ::ProtocolBuffers::Message
          repeated RpbPair, :fields, 1
        end

        class RpbSearchQueryReq < ::ProtocolBuffers::Message
          required :bytes, :q, 1
          required :bytes, :index, 2
          optional :uint32, :rows, 3
          optional :uint32, :start, 4
          optional :bytes, :sort, 5
          optional :bytes, :filter, 6
          optional :bytes, :df, 7
          optional :bytes, :op, 8
          repeated :bytes, :fl, 9
          optional :bytes, :presort, 10
        end

        class RpbSearchQueryResp < ::ProtocolBuffers::Message
          repeated RpbSearchDoc, :docs, 1
          optional :float, :max_score, 2
          optional :uint32, :num_found, 3
        end

        MessageClasses = [
            RpbErrorResp, nil, nil, nil, RpbGetClientIdResp, RpbSetClientIdReq, nil, nil,
            RpbGetServerInfoResp, RpbGetReq, RpbGetResp, RpbPutReq, RpbPutResp, RpbDelReq, nil, RpbListBucketsReq,
            RpbListBucketsResp, RpbListKeysReq, RpbListBucketsResp, RpbGetBucketReq, RpbGetBucketResp, RpbSetBucketReq, nil, RpbMapRedReq,
            RpbMapRedResp, RpbIndexReq, RpbIndexResp, RpbSearchQueryReq, RpbSearchQueryResp
        ]
      end
    end
  end
end
