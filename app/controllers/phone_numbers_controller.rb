class PhoneNumbersController < ApplicationController
  def update
    @phone_number = PhoneNumber.find params[:id]

    respond_to do |format|
      if @phone_number.update_attributes(params[:phone_number])
        format.html { redirect_to(@phone_number, :notice => 'Phone number was successfully updated.') }
        format.json { respond_with_bip(@phone_number) }
      else
        format.html { render :action => "edit" }
        format.json { respond_with_bip(@phone_number) }
      end
    end
  end

  def new
    @person = Person.find(params[:person_id])
    @phone_number = @person.phone_numbers.build
  end

  def create
    @person = Person.find(params[:person_id])
    @phone_number = @person.phone_numbers.create(params[:phone_number])
  end

  def destroy
    @phone_number = PhoneNumber.find(params[:id])
    @person = @phone_number.person
    @phone_number.destroy
  end

end
