# -*- encoding: utf-8 -*-
require 'rails_helper'

describe ReleaseEvent do
  let(:valid_attrs) do
    {
      :summary => "Summary text at #{DateTime.now}",
      :start_datetime => DateTime.now,
      :end_datetime => DateTime.now,
    }
  end

  let(:a_relinfo) do
    ReleaseEvent.new valid_attrs
  end

  it "can be create by request param" do
    rparam = {
      "summary"=>"テスト",
      "tag_names_str"=>"タグ",
      "location"=>"場所",
      "uri"=>"http://www.yahoo.co.jp/",
      "twitter_hash"=>"twash",
      "start_date"=>"2012-12-10",
      "start_time"=>"00:00",
      "allday"=>"0",
      "end_date"=>"",
      "end_time"=>"",
      "description"=>"desc!\r\n゛たよ",
      "producers_str"=>"Pさん",
      "movie_authors_str"=>"どうが",
      "illust_authors_str"=>"えし",
      "vocaloid_chars"=>["初音ミク", "GUMI"],
      "media"=>["YouTube", "Viemo"]
    }
    r = ReleaseEvent.new(rparam)
    expect(r.save).to be_truthy

    r = ReleaseEvent.create!(rparam)
    expect(r).to be_valid
  end

  it "provides extra filed accessors" do
    r = a_relinfo
    %w(producers media vocaloid_chars movie_authors illust_authors).each do |f|
      expect(r.__send__(f)).to eq []
    end
  end

  it "can store extra fileds" do
    r = a_relinfo
    r.movie_authors = ["Michael Francis Moore", "Peter Yates"]
    expect(r.save).to be_true

    rn = ReleaseEvent.find(r.id)
    expect(rn.movie_authors).to eq ["Michael_Francis_Moore", "Peter_Yates"]

    expect(rn.movie_author_tags[0].name).to eq "Michael_Francis_Moore"
    expect(rn.movie_author_tags[1].name).to eq "Peter_Yates"
  end
end
