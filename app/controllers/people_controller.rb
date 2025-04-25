class PeopleController < ApplicationController
  before_action :set_person, only: %i[show edit update destroy]

  def title_content
    content_for :title do
      @person.name
    end
  end

  def index
    @people = Person.all.order(:name)
    @heading = "All Teachers"
  end

  def facilitators
    @people = Person.for_event(@event).order(:name)
    @heading = "Teachers"

    render :index
  end

  def new
    @person = Person.new
  end

  def create
    @person = Person.new(person_params)
    if @person.save
      redirect_to [@person], notice: "Person was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    Person.find(params[:id])
    if @person.update(person_params)
      redirect_to [@person], notice: "Person was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @person.destroy!
    redirect_to people_path, notice: "Person was successfully destroyed.", status: :see_other
  end

  private

  def person_params
    params.expect(person: [:name, :bio])
  end

  def set_person
    @person = Person.find(params.expect(:id))
  end
end
