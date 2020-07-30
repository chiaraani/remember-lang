module WordsHelper
	def next_review(word)
		if word.postpone
			'It is postponed.'
		elsif word.reviews.pending.count == 1
			'It should be reviewed today.'
		elsif word.reviews.notperformed.count == 1
			'It may be reviewed in ' + pluralize((word.reviews.last.scheduled_for - Date.today).to_i, 'day') + '.'
		else
			'There is not a future schedueld review.'
		end
	end
end
