namespace :db  do
  desc "Reloads all the chapters. You might want to run db:remove_chapters before."
  task reload_chapters: :environment do
    Chapter.reload!
  end
end
namespace :db  do
  desc "Removes all the chapters from the database."
  task remove_chapters: :environment do
    Chapter.destroy_all
  end
end
