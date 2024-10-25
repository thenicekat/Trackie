import { Platform } from "react-native";

export const keyboardVerticalOffset = Platform.OS === 'ios' ? 90 : 0;
export const keyboardAvoidingBehavior = Platform.OS === 'ios' ? 'padding' : undefined;
