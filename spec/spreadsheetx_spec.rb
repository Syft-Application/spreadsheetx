require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Spreadsheetx" do
  
  it "opens xlsx files successfully" do
    
    # a valid xlsx file used for testing
    empty_xlsx_file = "#{File.dirname(__FILE__)}/../templates/spec.xlsx"
    workbook = SpreadsheetX.open(empty_xlsx_file)
    
  end
  
  it "allow accessing worksheets" do
    
    # a valid xlsx file used for testing
    empty_xlsx_file = "#{File.dirname(__FILE__)}/../templates/spec.xlsx"
    workbook = SpreadsheetX.open(empty_xlsx_file)
    
    workbook.worksheets.length.should == 2
    workbook.worksheets.last.name.should == 'Test'
    
  end
  
  it "allow accessing row counts" do
    
    # a valid xlsx file used for testing
    empty_xlsx_file = "#{File.dirname(__FILE__)}/../templates/spec.xlsx"
    workbook = SpreadsheetX.open(empty_xlsx_file)

    workbook.worksheets.last.row_count.should == 4
    
  end
  
  it "can be saved" do
  
    # a valid xlsx file used for testing
    empty_xlsx_file = "#{File.dirname(__FILE__)}/../templates/spec.xlsx"
    workbook = SpreadsheetX.open(empty_xlsx_file)
  
    new_xlsx_file = "#{File.dirname(__FILE__)}/../templates/spec_out.xlsx"
    workbook.save(new_xlsx_file)
  
  end
  
  it "can convert an address of a cell to a cell name" do
    
    SpreadsheetX::Worksheet.cell_id(1, 1).should == 'A1'
    SpreadsheetX::Worksheet.cell_id(2, 1).should == 'B1'
    SpreadsheetX::Worksheet.cell_id(27, 9).should == 'AA9'
    SpreadsheetX::Worksheet.cell_id(26, 4).should == 'Z4'
    SpreadsheetX::Worksheet.cell_id(820, 496).should == 'AEN496'
    
    
  end
  
  it "allows cell values to be updated" do
  
    # a valid xlsx file used for testing
    empty_xlsx_file = "#{File.dirname(__FILE__)}/../templates/spec.xlsx"
    workbook = SpreadsheetX.open(empty_xlsx_file)
  
    workbook.worksheets.last.update_cell(1, 1, 9)
    workbook.worksheets.last.update_cell(1, 2, 'A')
    workbook.worksheets.last.update_cell(1, 3, nil)

    new_xlsx_file = "#{File.dirname(__FILE__)}/../templates/spec_changed_out.xlsx"
    workbook.save(new_xlsx_file)
  
  end

  it "allows cells to be added" do
  
    # a valid xlsx file used for testing
    empty_xlsx_file = "#{File.dirname(__FILE__)}/../templates/spec.xlsx"
    workbook = SpreadsheetX.open(empty_xlsx_file)
  
    workbook.worksheets.last.update_cell(9, 9, 9)
    workbook.worksheets.last.update_cell(9, 10, 'A')

    new_xlsx_file = "#{File.dirname(__FILE__)}/../templates/spec_added_out.xlsx"
    workbook.save(new_xlsx_file)
  
  end
  
end
