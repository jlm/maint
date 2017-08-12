class Project < ActiveRecord::Base
  belongs_to :task_group
  has_many :events
  # self-reference: http://guides.rubyonrails.org/association_basics.html#self-joins
  has_many :subprojects, class_name: "Project", foreign_key: "base_id"
  belongs_to :base, class_name: "Project"
  belongs_to :editor

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

  def timeline_json
   # Put together a list of events in the format needed by the timeline plugin, from our events list.
    ev_list = []
    self.events.order(:date).each do |event|
      caption = event.name + (event.description && !event.description.empty? ? ": #{event.description}" : '')
      ev = {
          media: {
              url: '<blockquote>' + self.short_title + '</blockquote>',
              caption: caption
          },
          #text: event.name + ' ' + event.description,
          start_date: { day: event.date.day, month: event.date.month, year: event.date.year }
      }
      if event.end_date && event.date != event.end_date
        ev[:end_date] = { day: event.end_date.day, month: event.end_date.month, year: event.end_date.year }
      end
      ev_list << ev
    end
    tl = {
        title: {
            text: {
                headline: self.par_url.nil? ? self.short_title : link_to(self.short_title, self.par_url),
                text: self.title
            }
        },
        events: ev_list
    }
    tl.to_json
  end

  # :Designation, :Title, :ShortTitle, :ProjectType, :Status, :LastMotion, :DraftNo, :NextAction,
  # :PoolFormed, :Mec, :ParUrl, :CsdUrl, :ParApproval, :ParExpiry, :StandardApproval, :Published
  validates :title, presence: true
  validates :short_title, presence: true
  validates :project_type, inclusion: {in: projecttypes, message: "%{value} is not a valid Project Type"}
  validates :status, inclusion: {in: statuses, message: "%{value} is not a valid Status"}
  validates :last_motion, inclusion: {in: lastmotions, message: "%{value} is not a valid LastMotion"}, allow_blank: true
  validates :next_action, inclusion: {in: nextactions, message: "%{value} is not a valid Next Action"}

end
