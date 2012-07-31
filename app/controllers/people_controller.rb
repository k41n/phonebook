class PeopleController < ApplicationController

  def update
    @person = Person.find params[:id]

    respond_to do |format|
      if @person.update_attributes(params[:person])
        format.html { redirect_to(@person, :notice => 'Person was successfully updated.') }
        format.json { respond_with_bip(@person) }
      else
        format.html { render :action => "edit" }
        format.json { respond_with_bip(@person) }
      end
    end
  end

  def destroy
    @person = Person.find params[:id]
    @person.destroy
  end

  def gettext
    send_data Person.as_text, :filename => 'persons.txt', :type => 'text/plain'
  end

  def upsync
    @newborn, @updated, @deleted = Person.sync_with(params[:sync].read)
  end

  def new
    @person = Person.new
  end

  def create
    if Person.exists?(name: params[:person][:name])
      @person = Person.find_by_name(params[:person][:name])
    else
      @person = Person.create(params[:person])
      @new = true
    end
    unless @person.phone_numbers.map(&:number).include? params[:phone_number]
      @phone_number = @person.phone_numbers.create(number: params[:phone_number]) if @person.valid?
    end
  end

  def search
    @persons = Person.joins(:phone_numbers).where(['people.name LIKE ? OR phone_numbers.number LIKE ?',"%#{params[:therm]}%", "%#{params[:therm]}%"]).uniq{|x| x.id}
  end
end
