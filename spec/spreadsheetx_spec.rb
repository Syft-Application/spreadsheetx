require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe 'Spreadsheetx' do
  it 'opens xlsx files successfully' do
    # a valid xlsx file used for testing
    empty_xlsx_file = "#{File.dirname(__FILE__)}/../templates/spec.xlsx"
    SpreadsheetX.open(empty_xlsx_file)
  end

  it 'allow accessing worksheets' do
    # a valid xlsx file used for testing
    empty_xlsx_file = "#{File.dirname(__FILE__)}/../templates/spec.xlsx"
    workbook = SpreadsheetX.open(empty_xlsx_file)

    workbook.worksheets.length.should == 2
    workbook.worksheets.last.name.should == 'Test'
  end

  it 'allow accessing row counts' do
    # a valid xlsx file used for testing
    empty_xlsx_file = "#{File.dirname(__FILE__)}/../templates/spec.xlsx"
    workbook = SpreadsheetX.open(empty_xlsx_file)

    workbook.worksheets.last.row_count.should == 8
  end

  it 'can init XLSX file with string content' do
    # a valid xlsx file used for testing
    empty_xlsx_file = "#{File.dirname(__FILE__)}/../templates/spec.xlsx"
    content = File.read(empty_xlsx_file)
    workbook = SpreadsheetX.read(content)

    workbook.worksheets.last.row_count.should == 8
  end

  it 'can be saved' do
    # a valid xlsx file used for testing
    empty_xlsx_file = "#{File.dirname(__FILE__)}/../templates/spec.xlsx"
    workbook = SpreadsheetX.open(empty_xlsx_file)

    new_xlsx_file = "#{File.dirname(__FILE__)}/../templates/out/spec_out.xlsx"
    workbook.save(new_xlsx_file)
  end

  it 'can convert an address of a cell to a cell name' do
    SpreadsheetX::Worksheet.cell_id(1, 1).should == 'A1'
    SpreadsheetX::Worksheet.cell_id(2, 1).should == 'B1'
    SpreadsheetX::Worksheet.cell_id(27, 9).should == 'AA9'
    SpreadsheetX::Worksheet.cell_id(26, 4).should == 'Z4'
    SpreadsheetX::Worksheet.cell_id(820, 496).should == 'AEN496'

    SpreadsheetX::Worksheet.cell_address('AEN496').should == [820, 496]
  end

  it 'allows cell values to be updated' do
    # a valid xlsx file used for testing
    empty_xlsx_file = "#{File.dirname(__FILE__)}/../templates/spec.xlsx"
    workbook = SpreadsheetX.open(empty_xlsx_file)

    workbook.worksheets.last.update_cell(1, 1, 9)
    workbook.worksheets.last.update_cell(1, 2, 'A')
    workbook.worksheets.last.update_cell(1, 3, nil)

    new_xlsx_file = "#{File.dirname(__FILE__)}/../templates/out/spec_changed_out.xlsx"
    workbook.save(new_xlsx_file)
  end

  context 'when we need to update cell by name' do
    it 'updates' do
      empty_xlsx_file = "#{File.dirname(__FILE__)}/../templates/spec.xlsx"
      workbook = SpreadsheetX.open(empty_xlsx_file)

      cell_name = 'A1'
      workbook.worksheets.last.update_cell_by_name(cell_name, 9)
      col, row = SpreadsheetX::Worksheet.cell_address(cell_name)
      expect(workbook.worksheets.last.cell(col, row)).to eq '9'
      expect(workbook.worksheets.last.cell_by_name(cell_name)).to eq '9'
    end
  end

  it 'allows cells to be added' do
    # a valid xlsx file used for testing
    empty_xlsx_file = "#{File.dirname(__FILE__)}/../templates/spec.xlsx"
    workbook = SpreadsheetX.open(empty_xlsx_file)

    workbook.worksheets.last.update_cell(9, 9, 9)
    workbook.worksheets.last.update_cell(9, 10, 'A')

    new_xlsx_file = "#{File.dirname(__FILE__)}/../templates/out/spec_added_out.xlsx"
    workbook.save(new_xlsx_file)
  end

  it 'handles large numbers of rows and cols' do
    # a valid xlsx file used for testing
    empty_xlsx_file = "#{File.dirname(__FILE__)}/../templates/spec.xlsx"
    workbook = SpreadsheetX.open(empty_xlsx_file)

    500.times do |row|
      6.times do |col|
        random_string = (0...30).map { rand(65..89).chr }.join
        # ump the row because there is no row 0
        workbook.worksheets.last.update_cell((col + 1), (row + 1), random_string)
      end
    end

    new_xlsx_file = "#{File.dirname(__FILE__)}/../templates/out/spec_large_data.xlsx"
    workbook.save(new_xlsx_file)
  end

  it 'handles various types of content' do
    # a valid xlsx file used for testing
    empty_xlsx_file = "#{File.dirname(__FILE__)}/../templates/spec.xlsx"
    workbook = SpreadsheetX.open(empty_xlsx_file)

    workbook.worksheets.last.update_cell(9, 9, Time.now)
    workbook.worksheets.last.update_cell(1, 4, 'A string')
    workbook.worksheets.last.update_cell(9, 10, 'A string')
    workbook.worksheets.last.update_cell(9, 11, 10.3)
    workbook.worksheets.last.update_cell(9, 12, 53)
    workbook.worksheets.last.update_cell(9, 13, nil)

    new_xlsx_file = "#{File.dirname(__FILE__)}/../templates/out/spec_various_content.xlsx"
    workbook.save(new_xlsx_file)
  end

  it 'can read and return a list of number formats currently in the document' do
    # a valid xlsx file used for testing
    empty_xlsx_file = "#{File.dirname(__FILE__)}/../templates/spec.xlsx"
    workbook = SpreadsheetX.open(empty_xlsx_file)

    workbook.formats.count.should == 3
    workbook.formats.first.id.to_i.should > 0
    puts workbook.formats.first.format.should == '[$-F400]h:mm:ss\ AM/PM'

    new_xlsx_file = "#{File.dirname(__FILE__)}/../templates/out/spec_various_content.xlsx"
    workbook.save(new_xlsx_file)
  end

  it 'output instead of save' do
    empty_xlsx_file = "#{File.dirname(__FILE__)}/../templates/spec.xlsx"
    workbook = SpreadsheetX.open(empty_xlsx_file)

    workbook.worksheets.last.update_cell(1, 1, 'HELLO OUTPUT')

    tmp_file = Tempfile.new
    workbook.save(tmp_file.path)

    workbook = SpreadsheetX.open(tmp_file.path)
    expect(workbook.worksheets.last.cell(1, 1)).to eq 'HELLO OUTPUT'
  end

  it 'can set formats on cells' do
    # a valid xlsx file used for testing
    empty_xlsx_file = "#{File.dirname(__FILE__)}/../templates/spec.xlsx"
    workbook = SpreadsheetX.open(empty_xlsx_file)

    date_format = workbook.formats.first
    workbook.worksheets.last.update_cell(1, 8, Time.now, date_format)

    new_xlsx_file = "#{File.dirname(__FILE__)}/../templates/out/spec_cell_format.xlsx"
    workbook.save(new_xlsx_file)
  end

  context 'when we convert cell coordinates' do
    it 'converts' do
      expect(SpreadsheetX::Worksheet.cell_address('A1')).to eq [1, 1]
    end
    it 'converts double letter address' do
      expect(SpreadsheetX::Worksheet.cell_address('CV1')).to eq [100, 1]
    end
    it 'converts double letter address' do
      cell_address = SpreadsheetX::Worksheet.cell_id(100, 1)
      expect(SpreadsheetX::Worksheet.cell_address(cell_address)).to eq [100, 1]
    end
    it 'rises error on wrong name' do
      expect { SpreadsheetX::Worksheet.cell_address('A') }.to \
        raise_error('wrong excel cell name, please specify smth. like A1')
    end
  end
end
