package helpers

import (
	"mahesabu/graph/model"
	"time"
)

// WeekStart https://stackoverflow.com/a/52303730/8150077
func WeekStart(week int) time.Time {
	now := time.Now()
	// Start from the middle of the year:
	t := time.Date(now.Year(), 7, 1, 0, 0, 0, 0, now.Location())

	// Roll back to Monday:
	if wd := t.Weekday(); wd == time.Sunday {
		t = t.AddDate(0, 0, -6)
	} else {
		t = t.AddDate(0, 0, -int(wd)+1)
	}

	// Difference in weeks:
	_, w := t.ISOWeek()
	t = t.AddDate(0, 0, (week-w)*7)

	return t
}

func WeekRange(week int) (start, end time.Time) {
	start = WeekStart(week)
	end = start.AddDate(0, 0, 7).Add(-time.Second)
	return
}

func BeginningOfToday(t time.Time) time.Time {
	return time.Date(t.Year(), t.Month(), t.Day(), 0, 0, 0, 0, t.Location())
}

func EndOfToday(t time.Time) time.Time {
	return BeginningOfToday(t).AddDate(0, 0, 1).Add(-time.Second)
}

func BeginningYesterday(t time.Time) time.Time {
	return time.Date(t.Year(), t.Month(), t.Day(), 0, 0, 0, 0, t.Location()).AddDate(0, 0, -1)
}

func EndYesterday(t time.Time) time.Time {
	return BeginningYesterday(t).AddDate(0, 0, 1).Add(-time.Second)
}

func BeginningOfMonth(t time.Time) time.Time {
	return time.Date(t.Year(), t.Month(), 1, 0, 0, 0, 0, t.Location())
}

func EndOfMonth(t time.Time) time.Time {
	return BeginningOfMonth(t).AddDate(0, 1, 0).Add(-time.Second)
}

func BeginningOfLastMonth(t time.Time) time.Time {
	return time.Date(t.Year(), t.Month(), 1, 0, 0, 0, 0, t.Location()).AddDate(0, -1, 0)
}

func EndOfLastMonth(t time.Time) time.Time {
	return BeginningOfLastMonth(t).AddDate(0, 1, 0).Add(-time.Second)
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
	if args.Timeframe != nil {
		if *args.Timeframe == model.TimeframeTypeYesterday {
			StartDate = BeginningYesterday(time.Now())
			EndDate = EndYesterday(time.Now())
		} else if *args.Timeframe == model.TimeframeTypeThisWeek {
			_, week := time.Now().ISOWeek()
			StartDate, EndDate = WeekRange(week)
		} else if *args.Timeframe == model.TimeframeTypeLastWeek {
			_, week := time.Now().ISOWeek()
			StartDate, EndDate = WeekRange(week - 1)
		} else if *args.Timeframe == model.TimeframeTypeThisMonth {
			StartDate = BeginningOfMonth(time.Now())
			EndDate = EndOfMonth(time.Now())
		} else if *args.Timeframe == model.TimeframeTypeLastMonth {
			StartDate = BeginningOfLastMonth(time.Now())
			EndDate = EndOfLastMonth(time.Now())
		} else if *args.Timeframe == model.TimeframeTypeThisYear {
			StartDate = BeginningOfYear(time.Now())
			EndDate = EndOfYear(time.Now())
		} else {
			//Default is today
			StartDate = BeginningOfToday(time.Now())
			EndDate = EndOfToday(time.Now())
		}
	} else {
		if args.StartDate != nil && args.EndDate != nil {
			StartDate = *args.StartDate
			EndDate = *args.EndDate
		} else {
			//Default time is always 24 hours
			StartDate = BeginningOfToday(time.Now()) //default
			EndDate = EndOfToday(time.Now())         //default
		}
	}

	return StartDate, EndDate
}
