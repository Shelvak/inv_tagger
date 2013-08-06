namespace :tasks do
  desc 'Cleaning temp files'
  task :clean_temp_files do
    puts 'Cleaning'
    delete_files "#{Rails.root}/tmp/to_print"
    puts 'Ready'
  end

  private

  def delete_files(directory)
    %x{find #{directory} -type f | xargs rm -rfv  >> private/deleted-files }
  end
end
