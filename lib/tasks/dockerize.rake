desc "Testing environment and variables"
task :dockerize, [:version, :prog, :user, :project, :region] => :environment do |t, args|
  args.with_defaults(version: "v1", prog: "maint", user: "johnlmessenger", project: "rare-sound-107921", region: "eu.")
  puts "Dockerize with version #{args.version}"
  system "docker build -t #{args.user}/#{args.prog} ."
  system "docker tag #{args.user}/#{args.prog} #{args.region}gcr.io/#{args.project}/#{args.prog}:#{args.version}"
  system "gcloud docker push #{args.region}gcr.io/#{args.project}/#{args.prog}:#{args.version}"
end
