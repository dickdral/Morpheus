// @flow

import React from 'react';
import { Animated } from 'react-native';

type Props = {
  value: any,
  onFinish?: () => void,
  duration?: number,
  children?: (animation: Animated.Value) => React$Element<*>,
  useNativeDriver?: boolean,
}

class Animation extends React.Component {
  props: Props;
  state = {
    lastValue: this.props.value,
  };
  animation = new Animated.Value(0);

  componentWillReceiveProps(nextProps: Props) {
    if (nextProps.value !== this.props.value) {
      this.setState({ lastValue: this.props.value });
    }
  }

  componentDidUpdate(prevProps: Props) {
    if (prevProps.value !== this.props.value) {
      let from = prevProps.value;
      let to = this.props.value;

      if (!this.props.useNativeDriver) {
        console.warn(`Not running useNativeDriver on animation!`)
      }

      // TODO: Choose easing/spring using props?
      this.animation.setValue(0);
      Animated.timing(this.animation, {
        toValue: 1,
        duration: this.props.duration || 200,
        useNativeDriver: this.props.useNativeDriver || false,
      }).start(() => {
        if (this.props.onFinish) {
          this.props.onFinish({ from, to });
        }
      });
    }
  }

  render() {
    const { lastValue } = this.state;
    const { children, value } = this.props;

    if (!children) {
      return null;
    }
    return children(this.animation.interpolate({
      inputRange: [0, 1],
      outputRange: [lastValue, value],
    }));
  }
}

export default Animation;
