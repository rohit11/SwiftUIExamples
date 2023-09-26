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


```
import React from "react";
import { View, StyleSheet, Text } from "react-native";
import Svg, { Path, Circle, G } from "react-native-svg";

export type CircularSliderProps = {
  /** Radius of Circular Slider */
  trackRadius?: number;
  /** Size of Thumb*/
  thumbRadius?: number;
  /** Size of Track */
  trackWidth?: number;
  /** percentage to show progess */
  percentage?: number;
  /** Minimum value */
  minValue?: number;
  /** Maximum value */
  maxValue?: number;
  /** Color for Track  */
  trackColor?: string;
  /** Color for Track Tint  */
  trackTintColor?: string;
  /** Color for Thumb  */
  thumbColor?: string;
  /** Color for Thumb fill  */
  thumbFillColor?: string;
  /** Show Thumb on Track  */
  noThumb?: boolean;
  /** Show text on center of circle  */
  showText?: boolean;
  /** Text color for center of circle  */
  textColor?: string;
  /** Text Size for center of circle  */
  textSize?: number;
};

const CircularSlider: React.FC<CircularSliderProps> = ({
  /** prop1 description */
  thumbRadius = 12,
  trackRadius = 100,
  trackWidth = 5,
  trackTintColor = "#e1e8ee",
  trackColor = "#2089dc",
  percentage = 75,
  minValue = 0,
  maxValue = 100,
  noThumb = false,
  showText = false,
  thumbColor = "#2089dc",
  textColor = "#2089dc",
  thumbFillColor = 'white',
  textSize = 18,
}) => {
  trackRadius = trackRadius / 2
  thumbRadius = thumbRadius / 2
  percentage = percentage >= 100 ? 99.9 : percentage
  const valuePercentage = ((percentage - minValue) * 100) / maxValue;
  console.log(percentage)
  const strokeWidth = 4
  const maxAngle = 359.9
  const polarToCartesian = React.useCallback(
    (angleToChange: number) => {
      let r = trackRadius;
      let hC = trackRadius + thumbRadius + strokeWidth;
      let a = ((angleToChange - 90) * Math.PI) / 180.0;

      let x = hC + r * Math.cos(a);
      let y = hC + r * Math.sin(a);
      return { x, y };
    },
    [trackRadius, thumbRadius]
  );

  const width = (trackRadius + thumbRadius + strokeWidth) * 2;
  const startCoord = polarToCartesian(0);
  const endCoord = polarToCartesian(valuePercentage * 3.6);
  const endTintCoord = polarToCartesian(maxAngle);

  return (
    <View
      style={{ width, height: width }}
    >
      <Svg width={width} height={width} >
        <Path
          stroke={trackTintColor}
          strokeWidth={trackWidth}
          d={[
            "M",
            startCoord.x,
            startCoord.y,
            "A",
            trackRadius,
            trackRadius,
            0,
            maxAngle <= 180 ? "0" : "1",
            1,
            endTintCoord.x,
            endTintCoord.y,
          ].join(" ")}
        />
        <Path
          stroke={trackColor}
          strokeWidth={trackWidth}
          fill="none"
          d={`M${startCoord.x} ${startCoord.y
            } A ${trackRadius} ${trackRadius} 0 ${valuePercentage * 3.6 > 180 ? 1 : 0
            } 1 ${endCoord.x} ${endCoord.y}`}
        />

        <View
          style={{
            elevation: 1, // Add elevation to this view
            shadowColor: 'black',
            shadowOffset: { width: 0, height: 2 },
            shadowOpacity: 0.3,
            shadowRadius: 2,
            backgroundColor: 'transparent',
            alignItems: 'center', // Center align content horizontally
            justifyContent: 'center', // Center align content vertically
          }}
        >
          <Svg>
            <Circle cx={trackRadius + thumbRadius + strokeWidth} cy={trackRadius + thumbRadius + strokeWidth} r={32} fill="white" />
          </Svg>
          {showText && (
            <Text
              style={styles.centeredText}
            >
              {Math.ceil(percentage).toString()}
            </Text>
          )}
        </View>


        {!noThumb && (
          <G x={endCoord.x - thumbRadius} y={endCoord.y - thumbRadius}>
            <Circle
              r={thumbRadius}
              cx={thumbRadius}
              cy={thumbRadius}
              fill={thumbFillColor}
              strokeWidth={strokeWidth}
              stroke={thumbColor}
            />
          </G>
        )}
      </Svg>
    </View>
  );
};
CircularSlider.defaultProps = {};

export default CircularSlider;

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: "center",
    alignItems: "center",
    backgroundColor: "#e5e5e5",
  },
  headerText: {
    fontSize: 20,
    textAlign: "center",
    margin: 10,
    fontWeight: "bold"
  },
  CircleShape: {
    width: 64,
    height: 64,
    borderRadius: 64 / 2,
    backgroundColor: 'white',
    elevation: 1,
    alignItems: 'center'

  },

  centeredText: {
    position: 'absolute',
    textAlign: 'center',
    fontSize: 16,
    fontWeight: 'bold',
  },

});
```
