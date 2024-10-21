import { View, Text, StyleSheet, TextInput, TouchableOpacity, KeyboardAvoidingView, Platform, Alert } from 'react-native'
import React from 'react'
import { defaultStyles } from '@/constants/Styles'
import Colors from '@/constants/Colors';
import { Link, useRouter } from 'expo-router';
import { useNoteStore } from '@/store/noteStore';

const LogIn = () => {
    const [nameInput, setNameInput] = React.useState('');
    const keyboardVerticalOffset = Platform.OS === 'ios' ? 90 : 0;

    const router = useRouter();
    const { setName } = useNoteStore();


    const onBoard = (name: string) => {
        setName(name)
        router.push("/(tabs)/notes")
    };

    return (
        <KeyboardAvoidingView
            keyboardVerticalOffset={keyboardVerticalOffset}
            style={{ flex: 1 }}
            behavior={(Platform.OS === 'ios') ? "padding" : undefined}
            key="onboard"
        >
            <View style={defaultStyles.container}>
                <Text style={defaultStyles.header}>Welcome!</Text>
                <Text style={defaultStyles.descriptionText}>
                    Enter your information below to continue.
                </Text>


                <View style={styles.inputContainer}>
                    <TextInput
                        style={[styles.input, { flex: 1 }]}
                        placeholder="Name"
                        keyboardType='default'
                        value={nameInput}
                        onChangeText={setNameInput}
                    />
                </View>

                <TouchableOpacity style={[defaultStyles.pillButton, { backgroundColor: nameInput == '' ? Colors.primaryMuted : Colors.primary, marginBottom: 20 }]} onPress={() => onBoard(nameInput)}>
                    <Text style={defaultStyles.buttonText}>Continue.</Text>
                </TouchableOpacity>

                <View style={{ flexDirection: 'row', alignItems: 'center', gap: 16 }}>
                    <View style={{ flex: 1, height: StyleSheet.hairlineWidth, backgroundColor: Colors.gray }} />
                    <Text style={{ color: 'black', fontSize: 20 }}>OR</Text>
                    <View style={{ flex: 1, height: StyleSheet.hairlineWidth, backgroundColor: Colors.gray }} />
                </View>

                <TouchableOpacity style={[defaultStyles.pillButton, { backgroundColor: Colors.primary, marginVertical: 20 }]} onPress={() => {
                    setName("Anonymous")
                    onBoard("Anonymous")
                }}>
                    <Text style={defaultStyles.buttonText}>Stay Anonymous.</Text>
                </TouchableOpacity>
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

export default LogIn