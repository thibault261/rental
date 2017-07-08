require 'rails_helper'

RSpec.describe "rentals/index", type: :view do
  before(:each) do
    assign(:rentals, [
      Rental.create!(
        :name => "Name",
        :number => 2,
        :mileage => 3,
        :input_file => "Input File"
      ),
      Rental.create!(
        :name => "Name",
        :number => 2,
        :mileage => 3,
        :input_file => "Input File"
      )
    ])
  end

  it "renders a list of rentals" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => "Input File".to_s, :count => 2
  end
end
