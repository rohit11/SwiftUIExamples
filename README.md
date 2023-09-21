# SwiftUIExamples

/*
import React, { useState, useMemo, useCallback } from 'react';
import { View, Text, TouchableOpacity, StyleSheet, Button } from 'react-native';

const CalendarComponent = () => {
  const [selectedDates, setSelectedDates] = useState<number[]>([]); // Declare selectedDates as an array of numbers
  const [currentMonth, setCurrentMonth] = useState(new Date());

  // Function to handle date selection
  const handleDateSelect = useCallback(
    (date: number) => {
      // Check if the date is already selected
      if (selectedDates.includes(date)) {
        // If it's selected, remove it from the selectedDates array
        setSelectedDates(selectedDates.filter((d) => d !== date));
      } else {
        // If it's not selected, add it to the selectedDates array
        setSelectedDates([...selectedDates, date]);
      }
    },
    [selectedDates]
  );

  // Function to generate days of the displayed month
  // Function to generate days of the displayed month
const generateDaysOfMonth = useMemo(() => {
  const year = currentMonth.getFullYear();
  const month = currentMonth.getMonth();
  let daysInMonth = new Date(year, month + 1, 0).getDate(); // Declare as 'let' to update for leap years
  const firstDayOfMonth = new Date(year, month, 1).getDay();
  const days = [];

  // Function to check if a year is a leap year
  const isLeapYear = (year: number) => {
    return (year % 4 === 0 && year % 100 !== 0) || (year % 400 === 0);
  };

  // Update the number of days in February for leap years
  if (month === 1 && isLeapYear(year)) {
    daysInMonth = 29;
  }

  // Fill in the preceding empty slots in the first row
  for (let i = 0; i < firstDayOfMonth; i++) {
    days.push(<View key={`empty-${i}`} style={styles.emptyDay} />);
  }

  // Generate days of the month
  for (let i = 1; i <= daysInMonth; i++) {
    const isSelected = selectedDates.includes(i);

    days.push(
      <TouchableOpacity
        key={i}
        style={[
          styles.day,
          isSelected ? styles.selectedDay : null,
        ]}
        onPress={() => handleDateSelect(i)}
      >
        <Text style={isSelected ? styles.selectedText : null}>{i}</Text>
      </TouchableOpacity>
    );
  }

  return days;
}, [currentMonth, selectedDates]);

  

  // Function to handle month change
  const handleMonthChange = (next: boolean) => {
    const newMonth = new Date(currentMonth);
    newMonth.setMonth(currentMonth.getMonth() + (next ? 1 : -1));
    setCurrentMonth(newMonth);
  };

  return (
    <View style={styles.container}>
      <View style={styles.header}>
        <Button title="Previous Month" onPress={() => handleMonthChange(false)} />
        <Text>{currentMonth.toLocaleDateString('en-US', { month: 'long', year: 'numeric' })}</Text>
        <Button title="Next Month" onPress={() => handleMonthChange(true)} />
      </View>
      <View style={styles.daysOfWeek}>
        {['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'].map((day) => (
          <Text key={day} style={styles.dayOfWeek}>
            {day}
          </Text>
        ))}
      </View>
      <View style={styles.daysOfMonth}>{generateDaysOfMonth}</View>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    padding: 16,
  },
  header: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: 16,
  },
  daysOfWeek: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    marginBottom: 8,
  },
  dayOfWeek: {
    flex: 1,
    textAlign: 'center',
  },
  daysOfMonth: {
    flexDirection: 'row',
    flexWrap: 'wrap',
  },
  day: {
    width: 36, // 7 days in a week
    height: 36,
    aspectRatio: 1,
    justifyContent: 'center',
    alignItems: 'center',
  },
  selectedDay: {
    backgroundColor: 'blue',
    borderColor: 'blue',
    borderRadius: 18
  },
  selectedText: {
    color: 'white',
  },
  emptyDay: {
    width: 36, // 7 days in a week
    height: 36,
    aspectRatio: 1,
  },
});

export default CalendarComponent;

*/
