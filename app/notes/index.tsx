import { View, Text, ScrollView, Alert, TextInput, TouchableOpacity } from 'react-native'
import React from 'react'
import { Note, useNoteState } from '@/store/noteStore'
import tw from 'twrnc';
import { FontAwesome } from '@expo/vector-icons';
import { useRouter } from 'expo-router';
import Header from '@/components/Header';
import Colors from '@/constants/Colors';


const notes = () => {
    const { notes, deleteNote } = useNoteState();
    const router = useRouter();

    const [searchInput, setSearchInput] = React.useState('');
    const [filteredNotes, setFilteredNotes] = React.useState<Note[]>(notes);

    React.useEffect(() => {
        let searchInputLC = searchInput.toLowerCase();
        setFilteredNotes(notes.filter((note) => note.content.toLowerCase().includes(searchInputLC) || note.title.toLowerCase().includes(searchInputLC)));
    }, [searchInput, notes]);

    const deleteNoteWithID = (id: string) => {
        deleteNote(id)
    }

    return (
        <View style={{ flex: 1 }}>
            <Header />

            <View style={tw`px-4`}>
                <View style={tw`mb-4`}>
                    <Text style={tw`text-4xl font-bold`}>Your Notes.</Text>
                </View>

                <View style={tw`h-[1px] bg-slate-500 my-1 w-full`} />

                <View style={tw`flex-row my-2`}>
                    <TextInput
                        style={
                            tw`border-2 border-gray-300 p-3 w-full rounded-lg`
                        }
                        placeholder="Search."
                        keyboardType='default'
                        value={searchInput}
                        onChangeText={setSearchInput}
                    />
                </View>
            </View>

            <ScrollView
                style={tw`px-4 pb-4`}
            >
                {
                    filteredNotes.length == 0 ?
                        <View>
                            <Text style={tw`text-xl m-2`}>No notes found.</Text>
                        </View>
                        : filteredNotes.map((note) => (
                            <TouchableOpacity
                                key={note.id}
                                style={tw`bg-white p-2 my-2 rounded-lg flex-row justify-between`}
                                onPress={() => {
                                    router.push(`/notes/edit/${note.id}`)
                                }}
                            >

                                <View
                                    style={tw`flex-1 justify-center p-2`}
                                >
                                    <Text style={tw`text-xl font-bold uppercase`}>
                                        {note.hidden ? '*****' : note.title}
                                    </Text>
                                    <Text style={tw`text-lg`}>
                                        {note.hidden ? '*************' : note.content.slice(0, 10)}
                                    </Text>
                                </View>

                                <FontAwesome
                                    name="trash"
                                    size={30}
                                    color={'red'}
                                    style={tw`w-10 h-10 text-center m-2`}
                                    onPress={() => {
                                        Alert.alert('Confirm your deletion.', 'Are you sure you want to delete.', [
                                            {
                                                text: 'Yes',
                                                onPress: () => {
                                                    deleteNoteWithID(note.id)
                                                }
                                            },
                                            {
                                                text: 'No',
                                                onPress: () => { }
                                            }
                                        ])
                                    }}
                                />
                            </TouchableOpacity>
                        ))
                }
            </ScrollView >
            <TouchableOpacity
                style={{
                    position: 'absolute',
                    bottom: 30,
                    right: 30,
                    backgroundColor: Colors.primary,
                    width: 60,
                    height: 60,
                    borderRadius: 30,
                    justifyContent: 'center',
                    alignItems: 'center',
                    shadowColor: '#000',
                    shadowOffset: { width: 0, height: 2 },
                    shadowOpacity: 0.8,
                    shadowRadius: 2,
                    elevation: 5,
                }}
                onPress={() => {
                    router.push('/notes/create')
                }}
            >
                <FontAwesome name="plus" size={28} color="white" />
            </TouchableOpacity>
        </View>
    )
}

export default notes