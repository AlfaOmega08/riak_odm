require 'spec_helper'

def rbp_get_resp_stub
  RiakOdm::Client::ProtocolBuffers::Messages::RpbGetResp.new({
    content: [ RiakOdm::Client::ProtocolBuffers::Messages::RpbContent.new({
      value: 'fake content',
      content_type: 'text/plain'
    }) ],
    vclock: '123'
  })
end

describe RiakOdm::Finders do
  describe '#find' do
    context 'called with a single id' do
      it 'returns nil when the key is not in the bucket' do
        RiakOdm::Bucket.any_instance.stub(:find).and_return nil
        expect(Post.find('fake_key')).to be_nil
      end

      it 'returns a Document when found' do
        RiakOdm::Bucket.any_instance.stub(:find).and_return rbp_get_resp_stub
        expect(Post.find('real_key')).to be_a Post
      end
    end

    context 'called with an array of ids' do
      it 'returns an array of Documents' do
        RiakOdm::Bucket.any_instance.stub(:find).and_return rbp_get_resp_stub

        result = Post.find([ 'key1', 'key2', 'key3' ])
        expect(result.size).to be(3)
        result.each do |res|
          expect(res).to be_a Post
        end
      end

      it 'returns nil in the correct place of the returning array' do
        RiakOdm::Bucket.any_instance.stub(:find).and_return rbp_get_resp_stub, nil, rbp_get_resp_stub

        result = Post.find([ 'key1', 'key2', 'key3' ])
        expect(result.size).to be(3)
        expect(result[0]).to be_a Post
        expect(result[1]).to be_nil
        expect(result[2]).to be_a Post
      end
    end
  end

  describe '#find!' do
    context 'called with a singled id' do
      it 'raises a DocumentNotFound exception when the key is not in the bucket' do
        RiakOdm::Bucket.any_instance.stub(:find).and_return nil
        expect{ Post.find!('fake_key') }.to raise_error
      end

      it 'returns a Document when found' do
        RiakOdm::Bucket.any_instance.stub(:find).and_return rbp_get_resp_stub
        expect(Post.find!('real_key')).to be_a Post
      end
    end

    context 'called with an array of ids' do
      it 'raises a DocumentNotFound whenever a key is not found' do
        RiakOdm::Bucket.any_instance.stub(:find).and_return rbp_get_resp_stub, nil, rbp_get_resp_stub
        expect{ Post.find!([ 'key1', 'fake_key', 'key3' ]) }.to raise_error
      end

      it 'returns an array of Documents' do
        RiakOdm::Bucket.any_instance.stub(:find).and_return rbp_get_resp_stub

        result = Post.find!([ 'key1', 'key2', 'key3' ])
        expect(result.size).to be(3)
        result.each do |res|
          expect(res).to be_a Post
        end
      end
    end
  end

  describe '#find_by' do

  end
end