shared_examples_for "find" do  
  describe '#find' do
    before do
      @session.visit('/with_html')
    end

    it "should find the first element using the given locator" do
      @session.find('//h1').text.should == 'This is a test'
      @session.find("//input[@id='test_field']")[:value].should == 'monkey'
    end

    describe 'the returned node' do
      it "should act like a session object" do
        @session.visit('/form')
        @form = @session.find(:css, '#get-form')
        @form.should have_field('Middle Name')
        @form.should have_no_field('Languages')
        @form.fill_in('Middle Name', :with => 'Monkey')
        @form.click_button('med')
        extract_results(@session)['middle_name'].should == 'Monkey'
      end

      it "should scope CSS selectors" do
        @session.find(:css, '#second').should have_no_css('h1')
      end
    end

    context "with css selectors" do
      it "should find the first element using the given locator" do
        @session.find(:css, 'h1').text.should == 'This is a test'
        @session.find(:css, "input[id='test_field']")[:value].should == 'monkey'
      end
    end

    context "with xpath selectors" do
      it "should find the first element using the given locator" do
        @session.find(:xpath, '//h1').text.should == 'This is a test'
        @session.find(:xpath, "//input[@id='test_field']")[:value].should == 'monkey'
      end
    end

    context "with css as default selector" do
      before { Capybara.default_selector = :css }
      it "should find the first element using the given locator" do
        @session.find('h1').text.should == 'This is a test'
        @session.find("input[id='test_field']")[:value].should == 'monkey'
      end
      after { Capybara.default_selector = :xpath }
    end

    it "should return nil when nothing was found" do
      @session.find('//div[@id="nosuchthing"]').should be_nil
    end

    it "should accept an XPath instance and respect the order of paths" do
      @session.visit('/form')
      @xpath = Capybara::XPath.text_field('Name')
      @session.find(@xpath).value.should == 'John Smith'
    end

    context "within a scope" do
      before do
        @session.visit('/with_scope')
      end

      it "should find the first element using the given locator" do
        @session.within(:xpath, "//div[@id='for_bar']") do
          @session.find('.//li').text.should =~ /With Simple HTML/
        end
      end
    end
  end
end
