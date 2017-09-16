import React from 'react';
import { View, Text, Animated, TouchableWithoutFeedback } from 'react-native';

import Animation from './Animation';

class Button extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      pressed: false,
    };
  }

  render() {
    let {
      children,
      onPress,
      disabled,
      style,
    } = this.props;
    let { pressed } = this.state;

    return (
      <Animation useNativeDriver value={pressed ? 0.95 : 1}>
        { animation =>
          <TouchableWithoutFeedback
            onPress={onPress}
            onPressIn={() => this.setState({ pressed: true })}
            onPressOut={() => this.setState({ pressed: false })}
            disabled={disabled}
          >
            <Animated.View
              style={{
                transform: [{ scale: animation }],
              }}
            >
              <View style={style} children={children} />
            </Animated.View>
          </TouchableWithoutFeedback>
        }
      </Animation>
    );
  }
}

export default Button;
