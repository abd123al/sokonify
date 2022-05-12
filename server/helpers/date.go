package helpers

import (
	"mahesabu/graph/model"
	"time"
)

func BeginningOfDay(t time.Time) time.Time {
	return time.Date(t.Year(), t.Month(), t.Day(), 0, 0, 0, 0, t.Location())
}

func EndOfDay(t time.Time) time.Time {
	return BeginningOfDay(t).AddDate(0, 0, 1).Add(-time.Second)
}

func BeginningOfMonth(t time.Time) time.Time {
	return time.Date(t.Year(), t.Month(), 1, 0, 0, 0, 0, t.Location())
}

func EndOfMonth(t time.Time) time.Time {
	return BeginningOfMonth(t).AddDate(0, 1, 0).Add(-time.Second)
}

func BeginningOfYear(t time.Time) time.Time {
	return time.Date(t.Year(), 1, 1, 0, 0, 0, 0, t.Location())
}

func EndOfYear(t time.Time) time.Time {
	return BeginningOfYear(t).AddDate(1, 0, 0).Add(-time.Second)
}

func HandleStatsDates(args model.StatsArgs) (time.Time, time.Time) {
	var StartDate, EndDate time.Time

	//This will override defaults date if set
	if args.Period != nil {
		//todo week
		if *args.Period == model.PeriodTypeMonth {
			StartDate = BeginningOfMonth(time.Now())
			EndDate = EndOfMonth(time.Now())
		} else if *args.Period == model.PeriodTypeYear {
			StartDate = BeginningOfYear(time.Now())
			EndDate = EndOfYear(time.Now())
		} else {
			//Default
			StartDate = BeginningOfDay(time.Now())
			EndDate = EndOfDay(time.Now())
		}
	} else {
		if args.StartDate != nil && args.EndDate != nil {
			StartDate = *args.StartDate
			EndDate = *args.EndDate
		} else {
			//Default time is always 24 hours
			StartDate = BeginningOfDay(time.Now()) //default
			EndDate = EndOfDay(time.Now())         //default
		}
	}

	return StartDate, EndDate
}
