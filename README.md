# SwiftUIExamples

```
import React, { useState, useCallback, useMemo } from 'react';
import { View, Text, TouchableOpacity, StyleSheet } from 'react-native';

const Calendar = () => {
  const [selectedDates, setSelectedDates] = useState<Array<number>>([]);
  const [currentMonth, setCurrentMonth] = useState(new Date());
  const currentDate = new Date();

  const daysInMonth = useMemo(() => {
    const year = currentMonth.getFullYear();
    const month = currentMonth.getMonth() + 1;
    // Update the number of days in February for leap years
    var days = new Date(year, month, 0).getDate()
    if (month === 1 && isLeapYear) {
      days = 29;
   }
    return days;
  }, [currentMonth]);

  const isLeapYear = useMemo(() => {
    const year = currentMonth.getFullYear();
    return (year % 4 === 0 && year % 100 !== 0) || year % 400 === 0;
  }, [currentMonth]);

  const toggleDateSelection = useCallback(
    (day: number) => {
         const isNotCurrentMonth = isPastMonth()
      if (isNotCurrentMonth === false) {
      setSelectedDates((prevSelectedDates) => {
        if (prevSelectedDates.includes(day)) {
          return prevSelectedDates.filter((date) => date !== day);
        } else {
          return [...prevSelectedDates, day];
        }
      });
    }
    },
    [selectedDates]
  );

  const renderCalendarDays = useCallback(() => {
    let calendarDays: any[] = [];
    const firstDayOfMonth = new Date(
      currentMonth.getFullYear(),
      currentMonth.getMonth(),
      1
    ).getDay();

  
    const emptyDays = Array.from({ length: firstDayOfMonth }, () => null);
    calendarDays = [...calendarDays, ...emptyDays]
    const days = (Array.from({ length: daysInMonth }, (_, index) => index + 1))
    calendarDays = [...calendarDays, ...days]

    return calendarDays;
  }, [currentMonth, daysInMonth]);

  const isFutureDate = useCallback( (day: number) => {
    const isDisabled =
   currentMonth.getFullYear() > currentDate.getFullYear() ||
   (currentMonth.getFullYear() === currentDate.getFullYear() &&
     currentMonth.getMonth() > currentDate.getMonth()) ||
   (currentMonth.getFullYear() === currentDate.getFullYear() &&
     currentMonth.getMonth() === currentDate.getMonth() &&
     day > currentDate.getDate());
     return isDisabled
  }, [currentMonth]);

  const isPastMonth = useCallback( () => {
    const isPastMonth =
   currentMonth.getFullYear() < currentDate.getFullYear() ||
   (currentMonth.getFullYear() === currentDate.getFullYear() &&
     currentMonth.getMonth() < currentDate.getMonth())
     return isPastMonth
  }, [currentMonth]);

  const isTodaysMonth = useCallback( () => {
    const isTodaysMonth =
   (currentMonth.getFullYear() === currentDate.getFullYear() &&
     currentMonth.getMonth() === currentDate.getMonth())
     return isTodaysMonth
  }, [currentMonth]);

  const renderDay = (day: number) => {
    const isSelected = selectedDates.includes(day);
   const isDisabled = isFutureDate(day);
    return (
      <TouchableOpacity
        key={day}
        disabled={isDisabled}
        style={[
          styles.dayContainer,
          {
            backgroundColor: isSelected ? 'blue' : 'transparent',
          },
        ]}
        onPress={() => toggleDateSelection(day)}
      >
        <View
          style={[
            styles.dayCircle,
            {
              borderColor: isSelected ? 'white' : 'transparent',
            },
          ]}
        >
          <Text
            style={[styles.dayText,{
              color: isSelected ? 'white' : isDisabled ? '#CBCCCD' : 'black',
              textDecorationLine: isDisabled ? 'line-through' : 'none',
              textDecorationColor: isDisabled ? '#CBCCCD' : 'transparent',
            }, ]}
          >
            {day}
          </Text>
        </View>
      </TouchableOpacity>
    );
  };

  const handleNextMonth = () => {
    setSelectedDates([])
    const nextMonth = new Date(currentMonth);
    nextMonth.setMonth(currentMonth.getMonth() + 1);
    setCurrentMonth(nextMonth);
  };

  const handlePrevMonth = () => {
    setSelectedDates([])
    const nextMonth = new Date(currentMonth);
    nextMonth.setMonth(currentMonth.getMonth() - 1);
    setCurrentMonth(nextMonth);
  };

  return (
    <View>
      <View style={styles.header}>
      <Text>{currentMonth.toLocaleString('en-US', { month: 'long', year: 'numeric' })}</Text>
        <TouchableOpacity onPress={() => handlePrevMonth()}>
          <Text>Previous Month</Text>
        </TouchableOpacity>
        <TouchableOpacity 
        disabled=  {isTodaysMonth()}
        onPress={() => handleNextMonth()}
        >
          <Text>Next Month</Text>
        </TouchableOpacity>
      </View>
      <View style={styles.daysOfWeek}>
        {['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT'].map((day, index) => (
          <Text key={index} style={styles.dayOfWeekText}>
            {day}
          </Text>
        ))}
      </View>
      <View style={styles.calendarContainer}>
        {renderCalendarDays().map((day, index) => (
          <View key={index} style={styles.day}>
            {day !== null ? renderDay(day) : <Text />}
          </View>
        ))}
      </View>
    </View>
  );
};

const styles = StyleSheet.create({
  header: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    padding: 10,
  },
  daysOfWeek: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    padding: 10,
    paddingHorizontal: 0
  },
  dayOfWeekText: {
    flex: 1,
    textAlign: 'center',
    fontWeight: '600',
    fontSize: 14,
  },
  calendarContainer: {
    flexDirection: 'row',
    flexWrap: 'wrap',
  },
  day: {
    width: '14.28%', // 7 days in a week
    aspectRatio: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  dayText: {
    fontWeight: '500',
    fontSize: 18,
    textAlign: 'center',
    color: 'black'
  },
  dayContainer: {
    width: 35,
    height: 35,
    borderRadius: 17.5,
    alignItems: 'center',
    justifyContent: 'center',
  },
  dayCircle: {
    width: 35,
    height: 35,
    borderRadius: 17.5,
    borderWidth: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
});

export default Calendar;


```
