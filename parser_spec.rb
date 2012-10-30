require "./parser"

describe Parser do
  context "instance creation" do
    it 'should not raise error when create new instance' do
      expect lambda {
        Parser.new
      }.should_not raise_error
    end

    it 'should create new instance with default values' do
      parser = Parser.new
      parser.current_page.should == 0
      parser.parse_flag.should == 0
    end
  end

  describe "#load_document" do
    let(:parser) { Parser.new }

    context 'current_page == 0' do
      it 'should fetch html page' do
        response = parser.load_document
        response.should_not be_nil
      end
    end
  end

  describe "#parse_html" do
    let(:parser) { Parser.new }
      it 'should write results to array' do
        
      end  
  end

  describe '#in_date_range' do
    let(:parser) { Parser.new }
    context "true" do
      it { parser.in_date_range('29, October, 2012').should be_true }
    end
    context "false" do
      it { parser.in_date_range('21, October, 2012').should be_false }
    end
  end
end
