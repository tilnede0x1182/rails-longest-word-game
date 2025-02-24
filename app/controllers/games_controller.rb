require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }
  end

  def score
    @word = params[:word].upcase
    @letters = params[:letters].split
    session[:score] ||= 0

    if word_valid?(@word, @letters) && english_word?(@word)
      @message = "Bravo ! #{@word} est un mot valide."
      session[:score] += @word.length
    elsif !word_valid?(@word, @letters)
      @message = "Désolé, #{@word} ne peut pas être formé avec #{@letters.join(', ')}."
    else
      @message = "Désolé, #{@word} n'est pas un mot anglais valide."
    end
  end

  private

  def word_valid?(word, letters)
    word.chars.all? { |letter| word.count(letter) <= letters.count(letter) }
  end

  def english_word?(word)
    url = "https://dictionary.lewagon.com/#{word}"
    response = URI.open(url).read
    json = JSON.parse(response)
    json["found"]
  end
end
