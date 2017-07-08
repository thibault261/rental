require 'rails_helper'

RSpec.describe "rentals/show", type: :view do
  before(:each) do
    @rental = assign(:rental, Rental.create!(
      :name => "Name",
      :number => 2,
      :mileage => 3,
      :input_file => "Input File"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
    expect(rendered).to match(/Input File/)
  end
end
