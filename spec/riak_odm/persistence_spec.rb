require 'spec_helper'

describe RiakOdm::Persistence do
  before(:each) do
    Post.stub(:find).and_return { Post.allocate }
    RiakOdm::Bucket.any_instance.stub(:destroy)
  end

  describe '#new_record?' do
    it 'returns true on newly instantiated object' do
      post = Post.new
      expect(post.new_record?).to be_true
    end

    it 'returns false on new but saved objects' do
      post = Post.new
      post.save

      expect(post.new_record?).to be_false
    end

    it 'returns false on fetched objects' do
      post = Post.find('whatever')
      expect(post.new_record?).to be_false
    end
  end

  describe '#destroyed?' do
    it 'returns false on new instances' do
      post = Post.new
      expect(post.destroyed?).to be_false
    end

    it 'returns false on saved object' do
      post = Post.new
      post.save

      expect(post.destroyed?).to be_false
    end

    it 'returns false on fetched objects' do
      post = Post.find('whatever')
      expect(post.destroyed?).to be_false
    end

    it 'returns true on destroyed objects' do
      post = Post.find('whatever')
      post.destroy

      expect(post.destroyed?).to be_true
    end
  end

  describe '#persisted?' do
    it 'returns false on new instances' do
      post = Post.new
      expect(post.persisted?).to be_false
    end

    it 'returns true on saved objects' do
      post = Post.new
      post.save

      expect(post.persisted?).to be_true
    end

    it 'returns true on fetched objects' do
      post = Post.find('whatever')
      expect(post.persisted?).to be_true
    end

    it 'returns false on destroyed objects' do
      post = Post.find('whatever')
      post.destroy

      expect(post.persisted?).to be_false
    end
  end
end