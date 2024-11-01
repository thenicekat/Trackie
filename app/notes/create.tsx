import { View, Text, StyleSheet, KeyboardAvoidingView, Platform, TouchableOpacity, TextInput, Alert, ScrollView, Switch } from 'react-native'
import React from 'react'
import { useNoteState } from '@/store/noteStore'
import { defaultStyles } from '@/constants/Styles';
import tw from 'twrnc';
import Colors from '@/constants/Colors';
import { keyboardAvoidingBehavior, keyboardVerticalOffset } from '@/app/constants';
import uuid from 'react-native-uuid';
import { useRouter } from 'expo-router';


const addNotes = () => {
    const { addNote } = useNoteState();
    const router = useRouter();

    const [titleInput, setTitleInput] = React.useState('');
    const [contentInput, setContentInput] = React.useState('');
    const [hiddenInput, setHiddenInput] = React.useState(false);

    const createNote = () => {
        let id = uuid.v4().toString()
        addNote({
            id: id,
            title: titleInput,
            content: contentInput,
            hidden: hiddenInput
        })
        setTitleInput('')
        setContentInput('')
        Alert.alert(
            'Note Created!',
            'Your note has been created.',
        )
        router.replace('/notes')
    }

    return (
        <KeyboardAvoidingView
            keyboardVerticalOffset={keyboardVerticalOffset}
            style={{ flex: 1 }}
            behavior={keyboardAvoidingBehavior}
            key="addnote"
        >
            <ScrollView contentContainerStyle={{ flexGrow: 1 }}>

                <View style={tw`h-full p-4 w-full`}>
                    <View style={tw`mb-4`}>
                        <Text style={tw`text-4xl font-bold`}>Create Note.</Text>
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
                                multiline={true}
                            />
                        </View>

                        <View style={tw`justify-between flex-row w-full mb-2`}>
                            <Text style={tw`text-xl m-2`}>Hide the text on homescreen.</Text>

                            <Switch
                                ios_backgroundColor="#3e3e3e"
                                onValueChange={() => {
                                    setHiddenInput(!hiddenInput)
                                }}
                                value={hiddenInput}
                            />
                        </View>

                        <TouchableOpacity
                            style={[defaultStyles.pillButton, { backgroundColor: Colors.primary, marginBottom: 20 }]}
                            onPress={() => {
                                if (titleInput == '' || contentInput == '') {
                                    Alert.alert(
                                        'Confirm your creation.',
                                        'Are you sure you want to create a note with empty fields?',
                                        [
                                            {
                                                text: 'Yes',
                                                onPress: () => {
                                                    createNote()
                                                }
                                            },
                                            {
                                                text: 'No',
                                                onPress: () => {
                                                    return
                                                }
                                            }
                                        ])
                                } else {
                                    createNote()
                                }
                            }}
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