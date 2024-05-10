class Project < ApplicationRecord
  broadcasts_refreshes

  attr_writer :suppress_notifications

  POINT_SCALES = {
    'none' => [].freeze,
    'pivotal' => [0, 1, 2, 3].freeze,
    'fibonacci' => [1, 2, 3, 5, 8].freeze,
    'powers_of_two' => [1, 2, 4, 8].freeze,
    'linear' => [1, 2, 3, 4, 5].freeze
  }.freeze

  ITERATION_LENGTH_RANGE = (1..4).freeze

  MAX_MEMBERS_PER_CARD = 4

  extend FriendlyId
  friendly_id :name, use: :slugged, reserved_words: %w[new edit].freeze

  belongs_to :pivotal_project, foreign_key: :pivotal_id, touch: true, required: false

  has_many :changesets, dependent: :destroy
  has_many :memberships, dependent: :destroy
  def admin? user
    memberships.where(user: user).first&.admin?
  end

  has_many :users, -> { distinct }, through: :memberships
  has_many :stories, dependent: :destroy do
    def with_dependencies
      includes(:notes, :tasks)
    end
  end

  has_many :notes, through: :stories
  has_many :attachments_attachments, through: :notes

  has_many :activities, dependent: :destroy

  scope :joinable, -> { where(disallow_join: false) }
  scope :joinable_except, ->(project_ids) { joinable.where.not(id: project_ids) }

  accepts_nested_attributes_for :users, reject_if: :all_blank
  # These are the valid point scales for a project. These represent
  # the set of valid points estimate values for a story in this project.

  validates :point_scale, inclusion: { in: POINT_SCALES.keys,
                                       message: '%{value} is not a valid estimation scheme' }

  validates :iteration_length,
    numericality: { greater_than_or_equal_to: ITERATION_LENGTH_RANGE.min,
                    less_than_or_equal_to: ITERATION_LENGTH_RANGE.max, only_integer: true,
                    message: 'must be between 1 and 4 weeks' }

  validates :iteration_start_day,
    numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 6,
                    only_integer: true, message: 'must be an integer between 0 and 6' }

  validates :name, presence: true

  validates :default_velocity, numericality: { greater_than: 0,
                                               only_integer: true }

  scope :not_archived, -> { where(archived_at: nil) }
  scope :archived, -> { where.not(archived_at: nil) }

  def last_changeset_id
    changesets.last&.id
  end

  def to_param
    ::FriendlyId::Disabler.disabled? ? (id&.to_s) : super
  end

  def suppress_notifications
    @suppress_notifications || false
  end

  def to_s
    name
  end

  def iteration_service(since: nil, current_time: Time.zone.now)
    @iteration_service ||= IterationService.new(self, since: since, current_time: current_time)
  end

  delegate :completed_iterations, :backlog_iterations, to: :iteration_service

  def point_values
    POINT_SCALES[point_scale]
  end

  def archived
    !!archived_at
  end

  def archived=(value)
    self.archived_at = if !value || value == '0'
                         nil
                       else
                         Time.current
                       end
  end
end
