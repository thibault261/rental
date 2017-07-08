require 'rails_helper'

RSpec.describe "rentals/new", type: :view do
  before(:each) do
    assign(:rental, Rental.new(
      :name => "MyString",
      :number => 1,
      :mileage => 1,
      :input_file => "MyString"
    ))
  end

  it "renders new rental form" do
    render

    assert_select "form[action=?][method=?]", rentals_path, "post" do

      assert_select "input#rental_name[name=?]", "rental[name]"

      assert_select "input#rental_number[name=?]", "rental[number]"

      assert_select "input#rental_mileage[name=?]", "rental[mileage]"

      assert_select "input#rental_input_file[name=?]", "rental[input_file]"
    end
  end
end
