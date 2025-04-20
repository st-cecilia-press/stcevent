class MenusController < ApplicationController
  before_action :set_menu, only: %i[show edit update destroy]

  # GET /menus
  def index
    @menus = Menu.all
  end

  # GET /menus/1
  def show
  end

  # GET /menus/new
  def new
    @menu = Menu.new
  end

  # GET /menus/1/edit
  def edit
  end

  # POST /menus
  def create
    @menu = Menu.new(menu_params)

    if @menu.save
      redirect_to @menu, notice: "Menu was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /menus/1
  def update
    if @menu.update(menu_params)
      redirect_to @menu, notice: "Menu was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /menus/1
  def destroy
    @menu.destroy!
    redirect_to menus_path, notice: "Menu was successfully destroyed.", status: :see_other
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_menu
    @menu = Menu.find(params.expect(:id))
  end

  # Only allow a list of trusted parameters through.
  def menu_params
    params.expect(menu: [:order, :name, :event_id])
  end
end
