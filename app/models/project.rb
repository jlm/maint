class Project < ApplicationRecord
  belongs_to :task_group
  has_many :events
  has_many :motions
  # self-reference: http://guides.rubyonrails.org/association_basics.html#self-joins
  has_many :subprojects, class_name: "Project", foreign_key: "base_id"
  belongs_to :base, class_name: "Project", optional: true
  belongs_to :editor, optional: true

  def self.nextactions
    %w(ParDevelopment NesCom EditorsDraft TgBallot WgBallot SponsorBallot SponsorBallotCond RevCom
      RevComCond Publication Done ParMod ParWithdrawal Withdrawal)
  end

  def self.statuses
    %w(ParDevelopment NesCom ParApproved EditorsDraft TgBallot WgBallot TgBallotRecirc WgBallotRecirc
      SponsorBallot RevCom Approved Published Superseded Withdrawn )
  end

  def self.status_colours
    %w(warning primary info success danger warning primary info success danger warning primary info success danger )
  end

  def self.projecttypes
    %w(Amendment Corrigendum Revision NewStandard NewRecPractice Erratum)
  end

  def self.lastmotions
    %w(ParDevelopment NesCom TgBallot WgBallot SponsorBallot SponsorBallotCond RevCom RevComCond ParMod ParWithdrawal Withdrawal)
  end

  include ActionView::Helpers::UrlHelper

  # :Designation, :Title, :ShortTitle, :ProjectType, :Status, :LastMotion, :DraftNo, :NextAction,
  # :PoolFormed, :Mec, :ParUrl, :CsdUrl, :ParApproval, :ParExpiry, :StandardApproval, :Published
  validates_uniqueness_of :designation
  validates :title, presence: true
  validates :short_title, presence: true
  validates :project_type, inclusion: {in: projecttypes, message: "%{value} is not a valid Project Type"}
  validates :status, inclusion: {in: statuses, message: "%{value} is not a valid Status"}
  validates :last_motion, inclusion: {in: lastmotions, message: "%{value} is not a valid LastMotion"}, allow_blank: true
  validates :next_action, inclusion: {in: nextactions, message: "%{value} is not a valid Next Action"}

end
