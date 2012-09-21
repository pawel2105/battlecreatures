# used to store information about mxit profile
class MxitProfile

  attr_reader :language, :country, :dob, :gender, :tariff_plan

  delegate :month, :day, to: :dob_date, prefix: true
  delegate :month, :day, to: :current_date, prefix: true

  def initialize(mxit_profile)
    @language,@country,@dob,@gender,@tariff_plan = mxit_profile.split(',')
    @gender.downcase! if @gender
  end

  def age
    return nil if dob.blank?
    current_date.year - dob_date.year - (birthday_past? ? 0 : 1)
  end

  private

  def current_date
    @current_date ||= Time.current.to_date
  end

  def dob_date
    Date.parse(dob)
  end

  def birthday_past?
    current_date_month > dob_date_month || (current_date_month == dob_date_month && current_date_day >= dob_date_day)
  end

end