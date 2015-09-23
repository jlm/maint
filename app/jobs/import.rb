# https://github.com/d4be4st/progress_job_demo/blob/master/app/jobs/export_job.rb
class ImportJob < ProgressJob::Base
  def perform
    require 'csv'
    update_stage('Exporting users')
    users = User.first(10000)
    update_progress_max(users.count)
    csv_string = CSV.generate do |csv|
      users.each do |user|
        csv << [user.name, user.email]
        update_progress
      end
    end
    File.open('public/system/export.csv', 'w') { |f| f.write(csv_string) }
  end
end