class Tag < ActiveRecord::Base
  has_many :tag_relations, :class_name => 'EventTagRelation', :dependent => :delete_all
  has_many :events, :through => :tag_relations
  has_and_belongs_to_many :calendars
  belongs_to :link, :foreign_key => :primary_link_id,
    :class_name => 'ExLink', :autosave => true

  attr_accessible :name, :link_uri

  validates :name, :presence => true, :uniqueness => true,
    :format => {:with => /^\S+$/}

  after_validation :copy_link_errors

  def link?
    !!link
  end

  def link_uri
    link.try :uri
  end
  alias_method :uri, :link_uri

  def link_uri=(v)
    if v.blank?
      self.link = nil
    else
      self.link = ExLink.find_or_create_by_uri v
    end
  end
  alias_method :uri=, :link_uri=

  private
  def copy_link_errors
    errors.has_key? :"primary_link.uri" or return
    errors[:uri] = errors[:primary_link_uri] = errors[:"primary_link.uri"] 
  end
end
