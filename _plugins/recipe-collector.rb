require "recipe_collector"
require "dotenv"

# Load environment variables (NOTION_API_KEY)
Dotenv.load

module RecipeCollectorModule
  class RecipeCollectorWrapper
    @@recipe_data = nil
    def self.get_recipe_data(notion_api_key)
      if @@recipe_data.nil?
        @@recipe_data = RecipeCollector.new.get_recipe_data(notion_api_key)
      end
      @@recipe_data
    end
    def self.recipe_name_to_url(recipe_name)
      ru_to_en = {
        "а" => "a",
        "б" => "b",
        "в" => "v",
        "г" => "g",
        "д" => "d",
        "е" => "e",
        "ё" => "yo",
        "ж" => "zh",
        "з" => "z",
        "и" => "i",
        "й" => "j",
        "к" => "k",
        "л" => "l",
        "м" => "m",
        "н" => "n",
        "о" => "o",
        "п" => "p",
        "р" => "r",
        "с" => "s",
        "т" => "t",
        "у" => "u",
        "ф" => "f",
        "х" => "h",
        "ц" => "c",
        "ч" => "ch",
        "ш" => "sh",
        "щ" => "shh",
        "ъ" => "",
        "ы" => "y",
        "ь" => "",
        "э" => "e",
        "ю" => "yu",
        "я" => "ya",
      }
      recipe_name.strip.downcase.gsub(' ', '-').gsub(/[а-я]/, ru_to_en)
    end
  end

  class RecipeCollectorNamesTag < Liquid::Tag

    def initialize(tag_name, text, tokens)
      super
      @text = text
    end

    def render(context)
      notion_api_key = ENV['NOTION_API_KEY']
      # Get recipe data
      recipe_data = RecipeCollectorWrapper.get_recipe_data(notion_api_key)
      # Prepend each name with a dash
      recipe_names = recipe_data.map { |recipe| "- <a href=\"#{RecipeCollectorWrapper.recipe_name_to_url(recipe['name'])}\">#{recipe['name'].strip}</a>\n\n" }
      # Join the array into a string
      recipe_names.join("\n")
    end
  end

  class RecipeCollectorGenerator < Jekyll::Generator
    def generate(site) 
      recipe_data = RecipeCollectorWrapper.get_recipe_data(ENV['NOTION_API_KEY'])
      recipe_data.each do |recipe|
        site.pages << RecipePage.new(site, site.source, recipe["name"], recipe["text"], recipe["url"])
      end
    end
  end

  class RecipePage < Jekyll::Page 
    def initialize(site, base, recipe_name, recipe_text, recipe_url)
      @site = site
      @base = base
      @dir = "recipes/#{RecipeCollectorWrapper.recipe_name_to_url(recipe_name)}"

      @basename = 'index'
      @ext = '.html'
      @name = 'index.html'

      recipe_text_full = ""
      # if url is not nil, add a link to the recipe
      if recipe_url 
        recipe_text_full += "<a href=\"#{recipe_url}\">#{recipe_name}</a>\n\n"
      end
      recipe_text_full += recipe_text
      
      recipe_text_full.gsub!("\n", "<br>\n")

      @content = recipe_text_full

      @data = {
        'layout' => 'page',
        'title' => recipe_name
      }
    end
  end
end

Liquid::Template.register_tag('recipes_collector_names', RecipeCollectorModule::RecipeCollectorNamesTag)
