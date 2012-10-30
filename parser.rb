require "nokogiri"
require "time"
require "open-uri"

class Parser

  DAYS_RANGE = 7
  MAIN_PAGE_LINK = "http://eztv.it"
  SUBPAGE_LINK = "http://eztv.it/page_%i"

  attr_accessor :current_page, :file_name, :current_date, :parse_flag, :results

  def initialize
    @current_page = 0
    @parse_flag = 0
    @file_name = ""
    @results = []
  end

  def get_series(file)
    if file.to_s != ""
      @file_name = file
    end

    while @parse_flag < 1 do
      @parse_flag = 1
      doc = load_document
      unless doc.nil? 
        links = parse_html(doc)
      end
      @current_page += 1
    end

    print_results
  end

  def load_document
    response = if @current_page == 0
                Nokogiri::HTML(open(MAIN_PAGE_LINK))  
               else
                url = SUBPAGE_LINK % @current_page
                Nokogiri::HTML(open(url))
               end
    if response
      response
    else
      nil
    end  
  end

  def parse_html(document)
    document.css("table.forum_header_border").css("tr").each do |row|
      if row["class"] == "forum_space_border"  # Tr z datą
        @current_date = row.css("b").text
      elsif row["class"] == "forum_header_border" # Tytuł serialu
        magnet_link = ""
        serial_title = row.css(".forum_thread_post").css(".epinfo").text
        row.css(".forum_thread_post").css(".magnet").each do |result|
          magnet_link = result["href"]    # Magnet link"
        end 

        if in_date_range(@current_date.to_s)
          @parse_flag = 0
          if @file_name.to_s == "" || serial_title.downcase.index(@file_name.to_s.downcase)   # Wyszukiwanie nazwy serialu w nazwie pliku
            @results << @current_date.to_s + " --- " + serial_title + " --- " + magnet_link
          end
        end
      end  
    end  
  end

  def in_date_range(date_in_string)
    date = Time.parse date_in_string
    (Time.now - date).to_i/(60*60*24) < DAYS_RANGE
  end  

  def print_results
    if @results.any?
      @results.each do |result|
        puts result
      end  
    end  
  end  
end
