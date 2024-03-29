import { TUntrustedData } from '@/types'
import {
  getChannel,
  getQuestionFromId,
  saveUser,
  saveUserQuestionResponse,
} from './database-operations'
import { generateFarcasterFrame, SERVER_URL } from './generate-frames'
import { IMAGES } from './image-paths'
const QUESTION_ID = parseInt(process.env.QUESTION_ID || '')
console.log('QUESTION_ID', QUESTION_ID)
//to the bottom of the image here
export const HANDLE_QUESTION = async (
  ud: TUntrustedData,
  channelName: string
) => {
  const question = await getQuestionFromId(QUESTION_ID)
  console.log(channelName, 'wats channelname?')
  const channel = await getChannel(channelName)
  console.log(channel, 'wats chanel')
  const user = await saveUser(ud)
  console.log({ user })
  let questionButtonIndex = question?.options[ud.buttonIndex - 1]
  if (questionButtonIndex && user) {
    const correctResponse =
      questionButtonIndex.toLocaleLowerCase() ===
      question?.correct_response.toLocaleLowerCase()

    const html = await saveUserQuestionResponse(
      ud,
      user.id,
      correctResponse as boolean,
      questionButtonIndex,
      channel.id
    )
    return html
  } else
    return generateFarcasterFrame(`${SERVER_URL}/${IMAGES.welcome}`, 'start')
}
