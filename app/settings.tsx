import { View, Text, StyleSheet, TextInput, TouchableOpacity, KeyboardAvoidingView, Platform, Switch } from 'react-native'
import React from 'react'
import { defaultStyles } from '@/constants/Styles'
import Colors from '@/constants/Colors';
import { useRouter } from 'expo-router';
import { useNoteState } from '@/store/noteStore';
import { keyboardAvoidingBehavior, keyboardVerticalOffset } from '@/app/constants';
import { inactivityMMKVStorage } from '@/store/mmkv';
import tw from 'twrnc'

const Settings = () => {
    const { name, setName } = useNoteState();

    const [nameInput, setNameInput] = React.useState(name);
    const [lockEnabled, setLockEnabled] = React.useState(
        inactivityMMKVStorage.getBoolean('lockEnabled')
    );

    return (
        <KeyboardAvoidingView
            keyboardVerticalOffset={keyboardVerticalOffset}
            style={{ flex: 1 }}
            behavior={keyboardAvoidingBehavior}
            key="onboard"
        >
            <View style={defaultStyles.container}>
                <Text style={tw`text-2xl font-bold m-2`}>
                    Settings.
                </Text>


                <View style={styles.inputContainer}>
                    <TextInput
                        style={[styles.input, { flex: 1 }]}
                        placeholder="Update Name"
                        keyboardType='default'
                        value={nameInput}
                        onChangeText={setNameInput}
                    />
                </View>

                <TouchableOpacity style={[defaultStyles.pillButton, { backgroundColor: nameInput == '' ? Colors.primaryMuted : Colors.primary, marginBottom: 20 }]} onPress={() => {
                    setName(nameInput)
                }}>
                    <Text style={defaultStyles.buttonText}>Update Name.</Text>
                </TouchableOpacity>


                <View style={tw`justify-between flex-row w-full`}>
                    <Text style={tw`text-xl m-2`}>Lock the app.</Text>

                    <Switch
                        ios_backgroundColor="#3e3e3e"
                        onValueChange={() => {
                            inactivityMMKVStorage.set('lockEnabled', !lockEnabled)
                            setLockEnabled(!lockEnabled)
                        }}
                        value={lockEnabled}
                    />
                </View>

            </View >

        </KeyboardAvoidingView>
    )
}

const styles = StyleSheet.create({
    inputContainer: {
        marginVertical: 20,
        flexDirection: 'row',
    },
    input: {
        backgroundColor: Colors.lightGray,
        padding: 15,
        borderRadius: 16,
        fontSize: 18,
        marginRight: 10
    }
})

export default Settings