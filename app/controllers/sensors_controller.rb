class SensorsController < ApplicationController
  layout "dashboard"
  before_action :set_sensor, only: [:show, :edit, :update, :destroy]
  before_action :require_logged_in, only: [:index, :new, :edit, :create, :update, :destroy]
  before_action :default_values, only: [:new, :create, :update, :edit]


  def index
    @sensors = current_user.sensors.all
  end

  def show
    @axis_time = params[:axis_time]
    @grouped_data = []
    case @axis_time
    when "1" # 24-hour view selected
      minute_range = 1440
      @x_format = "HH:mm a"
      @graph_data = @sensor.graph_data(@sensor.events, minute_range)
      # Group two-dimensional array of hours, by hour
      @grouped_data = @graph_data.map { |arr| [] << arr[0].beginning_of_hour << arr[1] }.uniq { |x| x[0] }
      # Disregard values. Convert hours to two-dimensional array of one hour blocks
      @grouped_data = @grouped_data.map { |x| [] << @sensor.name << x[0] << x[0].end_of_hour }
    when "2" # week view selected
      minute_range = 10080
      @x_format = "MMM d"
      @graph_data = @sensor.graph_data(@sensor.events, minute_range)
      # Group two-dimensional array of days, by day
      @grouped_data = @graph_data.map { |arr| [] << arr[0].beginning_of_day << arr[1] }.uniq { |x| x[0] }
      # Disregard values. Convert days to two-dimensional array of one day blocks
      @grouped_data = @grouped_data.map { |x| [] << @sensor.name << x[0] << x[0].end_of_day }
    when "3" # month view selected
      minute_range = 40320
      @x_format = "d"
      @graph_data = @sensor.graph_data(@sensor.events, minute_range)
      # Group two-dimensional array of days, by day
      @grouped_data = @graph_data.map { |arr| [] << arr[0].beginning_of_day << arr[1] }.uniq { |x| x[0] }
      # Disregard values. Convert days to two-dimensional array of one day blocks
      @grouped_data = @grouped_data.map { |x| [] << @sensor.name << x[0] << x[0].end_of_day }
    when "4" # year view selected
      minute_range = 483840
      @x_format = "MMM"
      @graph_data = @sensor.graph_data(@sensor.events, minute_range)
      # Group two-dimensional array of days, by day
      @grouped_data = @graph_data.map { |arr| [] << arr[0].beginning_of_day << arr[1] }.uniq { |x| x[0] }
      # Disregard values. Convert days to two-dimensional array of one day blocks
      @grouped_data = @grouped_data.map { |x| [] << @sensor.name << x[0] << x[0].end_of_day }
    else
      minute_range = 1440
      @graph_data = @sensor.graph_data(@sensor.events, minute_range)
      # Group two-dimensional array of days, by day
      @grouped_data = @graph_data.map { |arr| [] << arr[0].beginning_of_day << arr[1] }.uniq { |x| x[0] }
      # Disregard values. Convert days to two-dimensional array of one day blocks
      @grouped_data = @grouped_data.map { |x| [] << @sensor.name << x[0] << x[0].end_of_day }
    end

  end

  def new
    @sensor = current_user.sensors.new
  end

  def edit
  end

  def create
    @sensor = current_user.sensors.new(sensor_params)
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
      format.html { redirect_to sensors_path, notice: 'Sensor was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sensor
      if current_user
        @sensor = current_user.sensors.find(params[:id])
      else
        # Determine if this user has set this sensor as public
        public_sensor = Sensor.find(params[:id]).public
        @sensor = Sensor.find(params[:id]) if public_sensor
      end
    end

    def default_values
      # params[:public] ||= false
      # params[:sensor][:type_of_graph] ||= 0

      # Used in the view to display humanized strings instead of snake_cased names
      # temp holds array of 2d array, Hash[] converts to single hash
      temp = Sensor.type_of_graphs.map {|key, value| [key.to_s.humanize, value]}
      @type_of_graphs = Hash[temp]
      temp = Sensor.notifications.map {|key, value| [key.to_s.humanize, value]}
      @notifications = Hash[temp]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def sensor_params
      params[:sensor][:unit] = params[:sensor][:unit].to_i
      params[:sensor][:kind] = params[:sensor][:kind].to_i
      params[:sensor][:type_of_graph] = params[:sensor][:type_of_graph].to_i
      params[:sensor][:notification] = params[:sensor][:notification].to_i
      params[:sensor][:notification_value] = params[:sensor][:notification_value].to_i
      if params[:sensor][:public] == "on"
        params[:sensor][:public] = true
      else
        params[:sensor][:public] = false
      end
      params.require(:sensor).permit(:name, :unit, :kind, :type_of_graph, :public, :notification, :notification_value)
    end
end
