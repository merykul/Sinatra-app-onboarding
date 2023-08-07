require 'axlsx'

class DownloadController < ApplicationController

  get '/exel_file_download' do
    @records = Records.all

    content_type 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
    attachment 'всі_записи.xlsx'

    Axlsx::Package.new do |p|
      p.workbook.add_worksheet(name: 'Records') do |sheet|
        sheet.add_row ['Name', 'Second Name', 'City/Village', 'DoB']
        @records.each { |record| sheet.add_row [record.first_name, record.second_name, record.city, record.date_of_birth] }
      end
    end.to_stream
  end
end
