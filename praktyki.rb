require "rubygems"
require "nokogiri"
require "open-uri"
require "date"

# Inicjacja zmiennych
currentPage = 0       # Numer strony z wynikami
$daysRange = 7        # Ilość dni z których pobierane są wyniki   
fileName = ""         # Opcjonalna nazwa szukanego pliku
currentDate = ""      # Data z nagłówka strony  
parseFlag = 0         # Flaga kończąca parsowanie stron
results = Array.new   # Tablica na wyniki
$months = {"January" => 1, "February" => 2, "March" => 3, "April" => 4,
           "May" => 5,"June" => 6, "July" => 7, "August" => 8,
           "September" => 9, "October" => 10, "November" => 11, "December" => 12}

# Metoda określająca czy data z nagłówka strony należy do poszukiwanego przedziału czasowego
def in_date_range(dateToCheck)
  dateNow = DateTime.now
  dateEnd = (dateNow - $daysRange)

  dateArray = dateToCheck.split(",")
 
  tmpDay = dateArray[0].strip.to_i
  tmpMonth = $months[dateArray[1].strip]
  tmpYear = dateArray[2].strip.to_i

  newDate = DateTime.new(tmpYear, tmpMonth, tmpDay, 23, 59)  

  if newDate >= dateEnd
    return true
  end

  return false
end  

# Zczytanie nazwy serialu do wyszukania
ARGV.each do |p|
  fileName += p + " "
end

while parseFlag < 1 do
  parseFlag = 1     # Pętla kończy się na stronie z brakiem dat należących do przedziału
  if currentPage == 0      # Wczytywanie html
    doc = Nokogiri::HTML(open("http://eztv.it"))
  else
    doc = Nokogiri::HTML(open("http://eztv.it/page_" + currentPage.to_s))
  end

  # Poszukiwanie po tr tabelki z wynikami
  
  doc.css(".forum_header_border").css("tr").each do |row|

    rowClass = row["class"]

    if rowClass == "forum_space_border"      # Tr z datą
      currentDate = row.css("b").text
    elsif rowClass == "forum_header_border"  # Tr z wynikiem
      serialTitle = row.css(".forum_thread_post").css(".epinfo").text  # Tytuł serialu
      magnetLink = ""
      row.css(".forum_thread_post").css(".magnet").each do |result|
        magnetLink = result["href"]   # Magnet link
      end

      if in_date_range(currentDate) # Sprawdzenie czy data należy do przedziału czasowego
        parseFlag = 0
        if fileName.to_s == "" || serialTitle.downcase.index(fileName.downcase)   # Wyszukiwanie nazwy serialu w nazwie pliku
          results << currentDate + " --- " + serialTitle + " --- " + magnetLink
        end
      end
    end
  end
  currentPage += 1 
end

# Wypisanie wyników
if results.any?
  results.each do |result|
    puts result
  end
end
