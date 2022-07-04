package helpers_test

import (
	"fmt"
	"mahesabu/graph/model"
	"mahesabu/helpers"
	"testing"
)

func TestDate(t *testing.T) {
	t.Run("BeginningOfToday", func(t *testing.T) {
		var timeframe model.TimeframeType

		timeframe = model.TimeframeTypeToday
		BeginningOfToday, EndOfToday := helpers.HandleStatsDates(model.StatsArgs{
			Timeframe: &timeframe,
		})

		timeframe = model.TimeframeTypeYesterday
		BeginningYesterday, EndYesterday := helpers.HandleStatsDates(model.StatsArgs{
			Timeframe: &timeframe,
		})

		timeframe = model.TimeframeTypeThisWeek
		BeginningOfWeek, EndOfWeek := helpers.HandleStatsDates(model.StatsArgs{
			Timeframe: &timeframe,
		})

		timeframe = model.TimeframeTypeLastWeek
		BeginningOfLastWeek, EndOfLastWeek := helpers.HandleStatsDates(model.StatsArgs{
			Timeframe: &timeframe,
		})

		timeframe = model.TimeframeTypeThisMonth
		BeginningOfMonth, EndOfMonth := helpers.HandleStatsDates(model.StatsArgs{
			Timeframe: &timeframe,
		})

		timeframe = model.TimeframeTypeLastMonth
		BeginningOfLastMonth, EndOfLastMonth := helpers.HandleStatsDates(model.StatsArgs{
			Timeframe: &timeframe,
		})

		timeframe = model.TimeframeTypeThisYear
		BeginningOfYear, EndOfYear := helpers.HandleStatsDates(model.StatsArgs{
			Timeframe: &timeframe,
		})

		fmt.Printf("BeginningOfToday: %s\n", BeginningOfToday)
		fmt.Printf("EndOfToday: %s\n", EndOfToday)

		fmt.Printf("BeginningYesterday: %s\n", BeginningYesterday)
		fmt.Printf("EndYesterday: %s\n", EndYesterday)

		fmt.Printf("BeginningOfWeek: %s\n", BeginningOfWeek)
		fmt.Printf("EndOfWeek: %s\n", EndOfWeek)

		fmt.Printf("BeginningOfLastWeek: %s\n", BeginningOfLastWeek)
		fmt.Printf("EndOfLastWeek: %s\n", EndOfLastWeek)

		fmt.Printf("BeginningOfMonth: %s\n", BeginningOfMonth)
		fmt.Printf("EndOfMonth: %s\n", EndOfMonth)

		fmt.Printf("BeginningOfLastMonth: %s\n", BeginningOfLastMonth)
		fmt.Printf("EndOfLastMonth: %s\n", EndOfLastMonth)

		fmt.Printf("BeginningOfYear: %s\n", BeginningOfYear)
		fmt.Printf("EndOfYear: %s\n", EndOfYear)
	})
}
