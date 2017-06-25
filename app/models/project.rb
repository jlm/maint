class Project < ActiveRecord::Base
  belongs_to :task_group
  # self-reference: http://guides.rubyonrails.org/association_basics.html#self-joins
  has_many :subprojects, class_name: "Project", foreign_key: "base_id"
  belongs_to :base, class_name: "Project"
  belongs_to :editor

  def self.nextactions
    %w(NesCom TgBallot WgBallot SponsorBallot SponsorBallotConditional RevCom
      RevComConditional Publication Done ParWithdrawal Withdrawal)
  end

  def self.statuses
    %w(ParDevelopment NesCom ParApproved EditorsDraft TgBallot WgBallot
      SponsorBallot RevCom Approved Published Superceded Withdrawn )
  end

  def self.status_colours
    %w(warning primary info success danger warning primary info success danger warning primary info success danger )
  end

  def self.projecttypes
    %w(Amendment Corridendum Revision NewStandard NewRecPractice Erratum)
  end

  def self.lastmotions
    %w(ParDevelopment NesCom TgBallot WgBallot SponsorBallot RevCom ParMod ParWithdrawal Withdrawal)
  end

  def timeline_json
    {
        title: {
            text: {
                headline: '<a href="' + self.par_url + '">' + self.short_title + '</a>',
                text: self.title
            }
        },
        events: [
            {
                media: {
                    url: '<blockquote>' + self.short_title + '</blockquote>',
                    caption: 'PAR Approved: ' + self.par_approval.to_s,
                    text: {
                        headline: "Apparently the nedia's text item does nothing",
                        text: self.par_approval.to_s
                    }
            },
                text: "PAR Approval",
                start_date: {day: self.par_approval.day, month: self.par_approval.month, year: self.par_approval.year}
            },
            {
                media: {
                    url: '<blockquote>' + self.short_title + '</blockquote>',
                    caption: 'PAR expires'
                },
                text: "PAR Expiry",
                start_date: {day: self.par_expiry.day, month: self.par_expiry.month, year: self.par_expiry.year}
            },
            {
                media: {
                    url: '<blockquote>' + self.short_title + '</blockquote>',
                    caption: 'Mandatory Editorial Coordination',
                    title: self.mec.to_s
                },
                text: "MEC",
                start_date: {day: self.mec.day, month: self.mec.month, year: self.mec.year}
            },
        ]
    }.to_json
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
