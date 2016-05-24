class SensorsController < ApplicationController
  layout "dashboard"
  before_action :set_sensor, only: [:show, :edit, :update, :destroy]
  before_action :require_logged_in
  before_action :default_values, only: [:create, :update]

  def index
    @sensors = current_user.sensors.all
  end

  def show
    @axis_time = params[:axis_time]
    case @axis_time
    when "1" # 24-hour view selected
      minute_range = 1440
      @x_format = "HH:mm a"
    when "2" # week view selected
      minute_range = 10080
      @x_format = "MMM d"
    when "3" # month view selected
      minute_range = 40320
      @x_format = "d"
    when "4" # year view selected
      minute_range = 483840
      @x_format = "MMM"
    else
      minute_range = 1440
    end
    # binding.pry
    @sensors = current_user.sensors.all
    sensor = current_user.sensors.find(params[:id])

    # Create array of two-dimensional arrays containing x and y values
    # uses last 24 hours worth of data
    @graph_data =[]
    sensor.events.each do | e |
      if (Time.now - e.capture_time) / 60 < minute_range
        @graph_data << [e.capture_time, e.value]
      end
    end

  end

  def new
    @sensor = current_user.sensors.new
  end

  def edit
  end

  def create
    @sensor = current_user.sensors.new(sensor_params)
    binding.pry
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
      format.html { redirect_to sensors_path, notice: 'Sensor was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sensor
      @sensor = current_user.sensors.find(params[:id])
    end

    def default_values
      # params[:public] ||= false
      params[:sensor][:type_of_graph] ||= 0

    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def sensor_params
      params[:sensor][:unit] = params[:sensor][:unit].to_i
      params[:sensor][:kind] = params[:sensor][:kind].to_i
      params[:sensor][:type_of_graph] = params[:sensor][:type_of_graph].to_i
      if params[:sensor][:public] == "on"
        params[:sensor][:public] = true
      else
        params[:sensor][:public] = false
      end
      params.require(:sensor).permit(:name, :unit, :kind, :type_of_graph, :public)
    end
end
