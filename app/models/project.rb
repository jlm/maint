class Project < ActiveRecord::Base
  belongs_to :task_group
  # self-reference: http://guides.rubyonrails.org/association_basics.html#self-joins
  has_many :subprojects, class_name: "Project", foreign_key: "base_id"
  belongs_to :base, class_name: "Project"

  def self.nextactions
    %w(NesCom TgBallot WgBallot SponsorBallot SponsorBallotConditional RevCom
      RevComConditional Publication Done ParWithdrawal Withdrawal)
  end

  def self.statuses
    %w(ParDevelopment NesCom ParApproved EditorsDraft TgBallot WgBallot
      SponsorBallot RevCom Approved Published Superceded Withdrawn )
  end

  def self.projecttypes
    %w(Amendment Corridendum Revision NewStandard NewRecPractice Erratum)
  end

  def self.lastmotions
    %w(ParDevelopment NesCom TgBallot WgBallot SponsorBallot RevCom ParMod ParWithdrawal Withdrawal)
  end

  # :Designation, :Title, :ShortTitle, :ProjectType, :Status, :LastMotion, :DraftNo, :NextAction,
  # :PoolFormed, :Mec, :ParUrl, :CsdUrl, :ParApproval, :ParExpiry, :StandardApproval, :Published
  validates :title, presence: true
  validates :short_title, presence: true
  validates :project_type, inclusion: {in: projecttypes, message: "%{value} is not a valid Project Type" }
  validates :status, inclusion: {in: statuses, message: "%{value} is not a valid Status" }
  validates :last_motion, inclusion: {in: lastmotions, message: "%{value} is not a valid LastMotion" }, allow_blank: true
  validates :next_action, inclusion: {in: nextactions, message: "%{value} is not a valid Next Action" }

end
