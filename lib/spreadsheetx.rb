require 'zip'
# we use this because it is WAY faster than rexml
require 'xml'
# for copying files
require 'fileutils'

require 'spreadsheetx/workbook'
require 'spreadsheetx/worksheet'
require 'spreadsheetx/cell_format'

module SpreadsheetX
  class << self
    def open(path)
      SpreadsheetX::Workbook.new(path)
    end

    def read(contents)
      SpreadsheetX::Workbook.read(contents)
    end
  end
end
