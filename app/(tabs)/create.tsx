import { View, Text, StyleSheet, KeyboardAvoidingView, Platform, TouchableOpacity, TextInput, Alert, ScrollView } from 'react-native'
import React from 'react'
import { useNoteStore } from '@/store/noteStore'
import { defaultStyles } from '@/constants/Styles';
import tw from 'twrnc';
import Colors from '@/constants/Colors';
import { keyboardAvoidingBehavior, keyboardVerticalOffset } from '@/app/constants';


const addNotes = () => {
    const { name, addNote } = useNoteStore();

    const [titleInput, setTitleInput] = React.useState('');
    const [contentInput, setContentInput] = React.useState('');

    const createNote = () => {
        addNote({
            id: Math.random().toString(36).substring(7),
            title: titleInput,
            content: contentInput
        })
        setTitleInput('')
        setContentInput('')
        Alert.alert(
            'Note Created!',
            'Your note has been created.',
        )
    }

    return (
        <KeyboardAvoidingView
            keyboardVerticalOffset={keyboardVerticalOffset}
            style={{ flex: 1 }}
            behavior={keyboardAvoidingBehavior}
            key="addnote"
        >
            <ScrollView contentContainerStyle={{ flexGrow: 1 }}>
                <Text style={[defaultStyles.sectionHeader, { marginTop: 50 }]}>
                    Hello! {name}
                </Text>

                <View style={tw`bg-gray-100 h-full p-4 w-full`}>
                    <View style={tw`mb-4`}>
                        <Text style={tw`text-4xl font-bold`}>Create New Note.</Text>
                    </View>

                    <View style={tw`h-[1px] bg-slate-500 my-1 w-full`} />

                    <View style={defaultStyles.container}>
                        <View style={styles.inputContainer}>
                            <TextInput
                                style={[styles.smolInput, { flex: 1 }]}
                                placeholder="Please enter a title."
                                keyboardType='default'
                                value={titleInput}
                                onChangeText={setTitleInput}
                            />
                        </View>

                        <View style={styles.inputContainer}>
                            <TextInput
                                style={[styles.bigInput, {
                                    flex: 1,
                                    alignContent: 'flex-start',
                                    verticalAlign: 'top'
                                }]}
                                placeholder="Please enter your note here."
                                keyboardType='default'
                                value={contentInput}
                                onChangeText={setContentInput}
                            />
                        </View>

                        <TouchableOpacity
                            style={[defaultStyles.pillButton, { backgroundColor: titleInput == '' ? Colors.primaryMuted : Colors.primary, marginBottom: 20 }]}
                            disabled={titleInput == ''}
                            onPress={createNote}
                        >
                            <Text style={defaultStyles.buttonText}>Create.</Text>
                        </TouchableOpacity>
                    </View >

                </View >
            </ScrollView>
        </KeyboardAvoidingView >
    )
}

const styles = StyleSheet.create({
    inputContainer: {
        marginVertical: 20,
        flexDirection: 'row',
    },
    smolInput: {
        backgroundColor: Colors.lightGray,
        padding: 15,
        borderRadius: 16,
        fontSize: 18,
        marginRight: 10
    },
    bigInput: {
        backgroundColor: Colors.lightGray,
        padding: 15,
        borderRadius: 16,
        fontSize: 18,
        marginRight: 10,
        height: 200
    }
})

export default addNotes