module Archivable
  extend ActiveSupport::Concern

  included do
    scope :unarchived, -> { where(archived_at: nil) }
    scope :archived, -> { where.not(archived_at: nil) }
  end

  def archive!
    self.archived_at = Time.now
    save! validate: false
  end

  def unarchive!
    self.archived_at = nil
    save! validate: false
  end

  def toggle_archive!
    if archived?
      unarchive!
    else
      archive!
    end
  end

  def archived?
    archived_at.present?
  end

  def unarchived?
    archived_at.nil?
  end

  # So that `delegate *Archivable.instance_methods, to: :model` also delegates archived_at and archived_at=
  def archived_at
    self[:archived_at]
  end

  def archived_at=(value)
    self[:archived_at] = value
  end
end
