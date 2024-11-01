import { View, Text, SafeAreaView, TouchableOpacity, Alert } from 'react-native'
import React from 'react'
import { defaultStyles } from '@/constants/Styles';
import tw from 'twrnc';
import { useNoteState } from '@/store/noteStore';
import * as LocalAuthentication from 'expo-local-authentication';
import { useRouter } from 'expo-router';
import { FontAwesome } from '@expo/vector-icons';


const lockScreen = () => {
    const { name } = useNoteState();
    const router = useRouter();

    const unlock = async () => {
        const hasHardware = await LocalAuthentication.hasHardwareAsync();
        if (!hasHardware) {
            router.replace('/');
        }

        const isEnrolled = await LocalAuthentication.isEnrolledAsync();
        if (!isEnrolled) {
            Alert.alert('No biometrics enrolled! Please set up biometrics in your device settings.');
            return;
        }

        const result = await LocalAuthentication.authenticateAsync({
            promptMessage: 'Please authenticate to unlock.',
        });

        if (result.success) {
            router.replace('/notes');
        }
    }

    return (
        <View
            style={tw`flex-1`}
        >
            <Text style={[defaultStyles.sectionHeader, { marginTop: 50 }]}>
                Hello! {name}
            </Text>

            <View style={tw`bg-gray-100 flex-1 p-4 w-full`}>
                <View style={tw`mb-4`}>
                    <Text style={tw`text-4xl font-bold`}>Locked.</Text>
                </View>

                <View style={tw`h-[1px] bg-slate-500 my-1 w-full`} />

                <View style={
                    tw`flex-1 p-2 m-2`
                }>
                    <TouchableOpacity
                        onPress={unlock}
                        style={tw`flex-1 justify-center items-center`}
                    >
                        <View style={tw`flex-1`} />
                        <Text style={
                            tw`text-lg font-bold text-gray-500`
                        }>Please click to unlock.</Text>

                        <FontAwesome name='lock' size={100} color='black' style={tw`text-center`} />
                    </TouchableOpacity>
                </View>
            </View>
        </View>
    )
}

export default lockScreen