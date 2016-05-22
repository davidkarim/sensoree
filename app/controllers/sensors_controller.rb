class SensorsController < ApplicationController
  layout "dashboard"
  before_action :set_sensor, only: [:show, :edit, :update, :destroy]
  before_action :require_logged_in

  def index
    @sensors = current_user.sensors.all
  end

  def show
    @sensors = current_user.sensors.all
    sensor = current_user.sensors.find(params[:id])

    # Create array of two-dimensional arrays containing x and y values
    @graph_data = sensor.events.map do | e |
      Array([e.capture_time, e.value])
    end

  end

  def new
    @sensor = current_user.sensors.new
  end

  def edit
  end

  def create
    @sensors = current_user.sensors.new(sensor_params)

    respond_to do |format|
      if @sensor.save
        format.html { redirect_to @sensor, notice: 'Sensor was successfully created.' }
        format.json { render :show, status: :created, location: @sensor }
      else
        format.html { render :new }
        format.json { render json: @sensor.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @sensor.update(sensor_params)
        format.html { redirect_to @sensor, notice: 'Sensor was successfully updated.' }
        format.json { render :show, status: :ok, location: @sensor }
      else
        format.html { render :edit }
        format.json { render json: @sensor.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @sensor.destroy
    respond_to do |format|
      format.html { redirect_to sensor_url, notice: 'Sensor was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sensor
      @sensor = current_user.sensors.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def sensor_params
      params.require(:sensor).permit(:name, :unit, :kind, :type_of_graph)
    end
end
